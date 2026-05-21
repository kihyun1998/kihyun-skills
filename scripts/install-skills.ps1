#Requires -Version 5.1
<#
.SYNOPSIS
  Symlink every skill in this repo into ~/.claude/skills so Claude Code loads them.

.DESCRIPTION
  A "skill" is any top-level directory in this repo that contains a SKILL.md.
  For each one, a directory symbolic link is created at
  $env:USERPROFILE\.claude\skills\<skill-name> pointing back into this repo.
  The repo stays the single source of truth; edits here are live immediately.

  Creating symlinks on Windows requires either:
    - Developer Mode enabled (Settings > Privacy & security > For developers), or
    - running this script from an elevated (Administrator) PowerShell.

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
        if ($item.LinkType -eq 'SymbolicLink') {
            Write-Host "  skip  $($skill.Name) - symlink already exists"
        } else {
            Write-Warning "  skip  $($skill.Name) - a real folder exists at $link; remove it first"
        }
        continue
    }

    try {
        New-Item -ItemType SymbolicLink -Path $link -Target $skill.FullName -ErrorAction Stop | Out-Null
        Write-Host "  link  $($skill.Name) -> $($skill.FullName)"
        $linked++
    } catch {
        Write-Warning "  fail  $($skill.Name) - $($_.Exception.Message)"
        Write-Warning '        Enable Developer Mode or run this script as Administrator, then retry.'
    }
}

Write-Host ''
Write-Host "Done. $linked skill(s) newly linked into $skillsHome."
