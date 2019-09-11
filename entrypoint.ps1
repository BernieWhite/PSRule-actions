#
# PSRule
#

# See details at: https://github.com/BernieWhite/PSRule-actions

$workspacePath = $Env:GITHUB_WORKSPACE;
$sourcePath = Join-Path -Path $workspacePath -ChildPath $Env:INPUT_SOURCE;

if (!(Test-Path -Path $sourcePath)) {
    Write-Host "`#`#[info] Source path '$sourcePath' does not exist.";
    return;
}

Write-Host "`#`#[group] Preparing PSRule";
$Null = Import-Module -Name /ps-rule/modules/PSRule;
$moduleVersion = (Get-Module PSRule).Version.ToString();
Write-Host "> Using PSRule -- v$moduleVersion";
Write-Host '';
Write-Host "> Using source: $sourcePath";
Write-Host "> Using workspace: $workspacePath";
Write-Host "`#`#[endgroup]";

Write-Host '> Executing rules';
Write-Host '';
Write-Host '---';

try {
    (Get-Item -Path $workspacePath), (Get-ChildItem -Path $workspacePath -File -Recurse) | Invoke-PSRule -Path $sourcePath -ErrorAction Stop;
}
catch {
    if ($_ -is [System.Exception]) {
        Write-Error -Exception $_;
    }
    else {
        Write-Error -ErrorRecord $_;
    }
    $Host.SetShouldExit(1);
}

Write-Host '---';
Write-Host '';
Write-Host '> All done.';
