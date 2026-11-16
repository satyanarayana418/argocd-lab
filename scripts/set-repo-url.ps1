# Windows version: replaces YOUR_GITHUB_USER in every YAML/Markdown file with your GitHub user name.
#   powershell -ExecutionPolicy Bypass -File scripts\set-repo-url.ps1 -GitHubUser <your-github-user>
param([Parameter(Mandatory = $true)][string]$GitHubUser)
$root = Split-Path $PSScriptRoot -Parent
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
Get-ChildItem $root -Recurse -File -Include *.yaml, *.yml, *.md | ForEach-Object {
    $text = [IO.File]::ReadAllText($_.FullName)
    if ($text.Contains('YOUR_GITHUB_USER')) {
        [IO.File]::WriteAllText($_.FullName, $text.Replace('YOUR_GITHUB_USER', $GitHubUser), $utf8NoBom)
        "updated  $($_.FullName.Substring($root.Length + 1))"
    }
}
"Repo URL is now: https://github.com/$GitHubUser/argocd-lab.git"
