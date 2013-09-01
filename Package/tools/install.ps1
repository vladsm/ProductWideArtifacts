param($installPath, $toolsPath, $package, $project)

Import-Module(Join-Path $toolsPath HelperUtils.psm1) -Force
Import-Module(Join-Path $toolsPath ProductWideUtils.psm1) -Force

#
# Remove dummy content
#
$dummyFileName = "Dummy.txt"
$project.ProjectItems | ForEach { if ($_.Name -eq $dummyFileName) {  $_.Remove() } }
Join-Path (Split-Path $project.FullName -Parent) $dummyFileName | Remove-Item


#
# Sign project output assembly with product SNK key
#
SignWithProductKey($project)

#
# Add code analysis dictionary
#
Add-ProductCodeAnalysisDictionary($project)
