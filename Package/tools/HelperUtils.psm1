#==================================================================================================
# Gets name (Name) and file path (FilePath) of the product-wide item in solution items folder,
# containing "CommonFiles" substring in its name. The name of the item should match wildcard pattern passed.
# If item is not found $null is returned.
#==================================================================================================
function Get-ProductWideItemInfo {
    param(
        $solution,
        [string] $wildcardPattern
    )

    $commonFiles = $null
    foreach($project in $solution.Projects)
    {
        if (($project.Name -like "*CommonFiles*")  -and ($project.Kind -eq "{66A26720-8FB5-11D2-AA7E-00C04F688DDE}"))
        {
            $commonFiles = $project
        }
    }

    if ($commonFiles -eq $null) { return $null }

    $productWideItem = $null
    foreach ($item in $commonFiles.ProjectItems)
    {
        if ($item.Name -like $wildcardPattern)
        {
            $productWideItem = $item
            break
        }
    }

    if ($productWideItem -eq $null) { return $null }

    return @{ 
        Name = $productWideItem.Name
        FilePath = $productWideItem.FileNames(1)
    }
}


#==================================================================================================
# Tries to find item named as @fileName in the Properties folder of the project represented
# with $project. If it is found it returns the item. Otherwise, adds the new item as a $filePath
# file link into Properties folder of the project and returns the item.
#==================================================================================================
function GetOrAddFileLinkToProjectPropertiesFolder
{
    param(
        $project,
        $fileName,
        $filePath
    )

    try
    {
        $propertiesFolderItem = $project.ProjectItems.Item("Properties")
    }
    catch
    {
        $propertiesFolderItem = $project
    }
    try
    {
        $item = $propertiesFolderItem.ProjectItems.Item($fileName)
    }
    catch
    {
        $item = $null
    }
    if ($item -eq $null)
    {
        $item = $propertiesFolderItem.ProjectItems.AddFromFile($filePath)
    }

    return $item
}


Export-ModuleMember Get-ProductWideItemInfo, GetOrAddFileLinkToProjectPropertiesFolder
