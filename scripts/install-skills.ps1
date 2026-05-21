#Requires -Version 5.1
<#
.SYNOPSIS
  Link every skill in this repo into ~/.claude/skills so Claude Code loads them.

.DESCRIPTION
  A "skill" is any top-level directory in this repo that contains a SKILL.md.
  For each one, a directory junction is created at
  $env:USERPROFILE\.claude\skills\<skill-name> pointing back into this repo.
  The repo stays the single source of truth; edits here are live immediately.

  This uses a directory junction rather than a symbolic link: junctions need
  no Developer Mode and no Administrator elevation. The only constraint is
  that the repo must live on a local drive (junctions cannot span to network
  locations) -- which is the normal case.

.EXAMPLE
  powershell -File .\scripts\install-skills.ps1
#>

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$repoRoot   = Split-Path -Parent $PSScriptRoot
$skillsHome = Join-Path $env:USERPROFILE '.claude\skills'

if (-not (Test-Path $skillsHome)) {
    New-Item -ItemType Directory -Path $skillsHome -Force | Out-Null
}

$skillDirs = Get-ChildItem -LiteralPath $repoRoot -Directory |
    Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') }

if (-not $skillDirs) {
    Write-Host 'No skills found (no top-level directory contains a SKILL.md).'
    return
}

$linked = 0
foreach ($skill in $skillDirs) {
    $link = Join-Path $skillsHome $skill.Name

    if (Test-Path $link) {
        $item = Get-Item -LiteralPath $link -Force
        if ($item.LinkType -in 'Junction', 'SymbolicLink') {
            Write-Host "  skip  $($skill.Name) - link already exists"
        } else {
            Write-Warning "  skip  $($skill.Name) - a real folder exists at $link; remove it first"
        }
        continue
    }

    try {
        New-Item -ItemType Junction -Path $link -Target $skill.FullName -ErrorAction Stop | Out-Null
        Write-Host "  link  $($skill.Name) -> $($skill.FullName)"
        $linked++
    } catch {
        Write-Warning "  fail  $($skill.Name) - $($_.Exception.Message)"
    }
}

Write-Host ''
Write-Host "Done. $linked skill(s) newly linked into $skillsHome."
