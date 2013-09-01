#==============================================================================
#
# Configures project to use product-wide SNK key for assembly signing. It puts a 
# link to the product-wide SNK key file into Properties directory of the project.
#
#==============================================================================
function SignWithProductKey {
    param($project)

    $solution = $dte.Solution
    $projectPath = Split-Path $project.FullName -Parent
    $solutionPath = Split-Path $solution.FullName -Parent

    #
    # Find product-wide snk file
    #
    $productWideSnk = Get-ProductWideItemInfo $solution "*.snk"
    if ($productWideSnk -eq $null)
    {
        Write-Host -BackgroundColor Yellow "Product-wide SNK file is not found."
        return
    }


    #
    # Add link to snk file from solution
    #
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
        $snkItem = $propertiesFolderItem.ProjectItems.Item($productWideSnk.Name)
    }
    catch
    {
        $snkItem = $null
    }
    if ($snkItem -eq $null)
    {
        $snkItem = $propertiesFolderItem.ProjectItems.AddFromFile($productWideSnk.FilePath)
    }

    #
    # Set the signing-related properties
    #
    $project.Properties.Item("SignAssembly").Value = $true;
    $project.Properties.Item("AssemblyOriginatorKeyFile").Value = $snkItem.FileNames(0)    

    $project.Save()
}


#==============================================================================
#
# Configures project to use product-wide code analysis dictionary. It puts a 
# link to the product-wide code analysis dictionary file into Properties
# directory of the project.
#
#==============================================================================
function Add-ProductCodeAnalysisDictionary
{
    param ($project)

    $solution = $dte.Solution
    $projectPath = Split-Path $project.FullName -Parent
    $solutionPath = Split-Path $solution.FullName -Parent

    #
    # Find product-wide code analysis dictionary file
    #
    $productWideDictionary = Get-ProductWideItemInfo $solution "*CodeAnalysisDictionary*.xml"
    if ($productWideDictionary -eq $null)
    {
        Write-Host -BackgroundColor Yellow "Product-wide Code Analysis dictionary is not found."
        return
    }

    #
    # Add link to code analysis dictionary file from solution
    #
    $dictionaryItem = GetOrAddFileLinkToProjectPropertiesFolder $project $productWideDictionary.Name $productWideDictionary.FilePath
    $dictionaryItem.Properties.Item("ItemType").Value = "CodeAnalysisDictionary";
    
    $project.Save()
}

Export-ModuleMember SignWithProductKey, Add-ProductCodeAnalysisDictionary
