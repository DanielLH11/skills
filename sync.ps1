# sync.ps1 — flatten organized skill sources into ~/.claude/skills/<skill>/
#
# Claude Code only discovers a skill when its SKILL.md is a DIRECT child of
# ~/.claude/skills/. This repo keeps the editable sources organized under
# engineering/ productivity/ misc/, so after editing any skill you must run
# this script to (re)generate the flat copies Claude actually reads.
#
# Non-destructive: it only ever removes/recreates a top-level folder that has
# a matching source under a category. It never touches the category folders,
# meta files, or any unrelated top-level entry.

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$categories = @('engineering', 'productivity', 'misc')
$count = 0

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

Write-Host "Synced $count skills into $root"
