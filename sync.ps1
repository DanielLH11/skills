# Sync the repository's canonical configuration into Claude Code's discovery paths.
#
# Skill sources stay organized under category directories and are flattened into
# direct children of ~/.claude/skills/ for discovery.
# AGENTS.md and agents/*.md are deployed to their live locations under ~/.claude/.
# Only same-named managed outputs are replaced, so unrelated agents are preserved.

$ErrorActionPreference = 'Stop'

$root = (Resolve-Path $PSScriptRoot).Path
$claudeRoot = Split-Path $root -Parent
$agentsSource = Join-Path $root 'agents'
$agentsDestination = Join-Path $claudeRoot 'agents'
$globalInstructionsSource = Join-Path $root 'AGENTS.md'
$globalInstructionsDestination = Join-Path $claudeRoot 'CLAUDE.md'
$categories = @('engineering', 'productivity', 'misc', 'marketing')
$count = 0

if ((Split-Path $root -Leaf) -ne 'skills' -or (Split-Path $claudeRoot -Leaf) -ne '.claude') {
    throw "This repository must be installed at ~/.claude/skills before it can be synced. Current path: $root"
}

if (-not (Test-Path $globalInstructionsSource -PathType Leaf)) {
    throw "Canonical global instructions were not found: $globalInstructionsSource"
}

if (-not (Test-Path $agentsSource -PathType Container)) {
    throw "Canonical agents directory was not found: $agentsSource"
}

$agentSources = @(Get-ChildItem -Path $agentsSource -Filter '*.md' -File)
if ($agentSources.Count -eq 0) {
    throw "No canonical agent definitions were found in $agentsSource"
}

foreach ($cat in $categories) {
    $catPath = Join-Path $root $cat
    if (-not (Test-Path $catPath)) { continue }
    foreach ($skill in Get-ChildItem -Path $catPath -Directory) {
        $dest = Join-Path $root $skill.Name
        if (Test-Path $dest) { Remove-Item -Path $dest -Recurse -Force }
        Copy-Item -Path $skill.FullName -Destination $dest -Recurse
        $count++
    }
}

Copy-Item -Path $globalInstructionsSource -Destination $globalInstructionsDestination -Force

if (-not (Test-Path $agentsDestination -PathType Container)) {
    New-Item -Path $agentsDestination -ItemType Directory | Out-Null
}

foreach ($agentSource in $agentSources) {
    $destination = Join-Path $agentsDestination $agentSource.Name
    Copy-Item -Path $agentSource.FullName -Destination $destination -Force
}

Write-Host "Synced $count skills into $root"
Write-Host "Synced $($agentSources.Count) agents into $agentsDestination"
Write-Host "Synced global instructions to $globalInstructionsDestination"
