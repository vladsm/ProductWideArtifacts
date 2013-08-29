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


Export-ModuleMember SignWithProductKey
