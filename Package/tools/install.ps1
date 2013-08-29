param($installPath, $toolsPath, $package, $project)

Import-Module(Join-Path $toolsPath HelperUtils.psm1) -Force
Import-Module(Join-Path $toolsPath ProductWideUtils.psm1) -Force

#
# Remove dummy content
#
$project.ProjectItems | ForEach { if ($_.Name -eq "Dummy.txt") {  $_.Remove() } }
Join-Path (Split-Path $project.FullName -Parent) "Dummy.txt" | Remove-Item


#
# Sign project output assembly with product SNK key
#
SignWithProductKey($project)
