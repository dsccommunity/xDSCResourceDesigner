# xDSCResourceDesigner

The **xDSCResourceDesigner** module is a part of the Windows PowerShell Desired State Configuration (DSC) Resource Kit, which is a tool to author PowerShell DSC Resources and produced by the PowerShell Team.This tool makes writing resources a breeze and ensure that all the rules which a DSC resource must conform to are met.

**All of the functions/cmdlets in the Resource Designer Tool are provided AS IS, and are not supported through any Microsoft standard support program or service.
The "x" in xDSCResourceDesigner stands for experimental**, which means that this tool will be **fix forward** and monitored by the module owner(s).

Please leave comments, feature requests, and bug reports in the Issues tab for this module.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Branches

### master

[![Build status](https://ci.appveyor.com/api/projects/status/a98sv7wqd9trdc41/branch/master?svg=true)](https://ci.appveyor.com/project/PowerShell/xDSCResourceDesigner/branch/master)
[![codecov](https://codecov.io/gh/PowerShell/xDSCResourceDesigner/branch/master/graph/badge.svg)](https://codecov.io/gh/PowerShell/xDSCResourceDesigner/branch/master)

This is the branch containing the latest release -
no contributions should be made directly to this branch.

### dev

[![Build status](https://ci.appveyor.com/api/projects/status/a98sv7wqd9trdc41/branch/dev?svg=true)](https://ci.appveyor.com/project/PowerShell/SqlServerDsc/branch/dev)
[![codecov](https://codecov.io/gh/PowerShell/xDSCResourceDesigner/branch/dev/graph/badge.svg)](https://codecov.io/gh/PowerShell/xDSCResourceDesigner/branch/dev)

This is the development branch
to which contributions should be proposed by contributors as pull requests.
This development branch will periodically be merged to the master branch,
and be released to [PowerShell Gallery](https://www.powershellgallery.com/).

## Contributing

If you would like to modify **xDSCResourceDesigner** module, feel free.
When modifying, please update the module name and the function names (instructions below).
As specified in the license, you may copy or modify this tool as long as they are used on the Windows Platform.

For more information about Windows PowerShell Desired State Configuration, check out the blog posts on the [PowerShell Blog](http://blogs.msdn.com/b/powershell/) ([this](http://blogs.msdn.com/b/powershell/archive/2013/11/01/configuration-in-a-devops-world-windows-powershell-desired-state-configuration.aspx) is a good starting point).
There are also great community resources, such as [PowerShell.org](http://powershell.org/wp/tag/dsc/), or [PowerShell Magazine](http://www.powershellmagazine.com/tag/dsc/).
For more information on the DSC Resource Kit, check out [this blog post](http://go.microsoft.com/fwlink/?LinkID=389546).

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

Please check out common DSC Resources [contributing guidelines](https://github.com/PowerShell/DscResource.Kit/blob/master/CONTRIBUTING.md).

## Installation

To install **xDSCResourceDesigner** module

* Unzip the content under $env:ProgramFiles\WindowsPowerShell\Modules folder

To confirm installation:

* Run **Get-Module -ListAvailable** to see that **xDSCResourceDesigner** is among the modules listed

## Requirements

This module requires the latest version of PowerShell (v4.0, which ships in Windows 8.1 or Windows Server 2012R2).
To easily use PowerShell 4.0 on older operating systems, [install WMF 4.0](http://www.microsoft.com/en-us/download/details.aspx?id=40855).
Please read the installation instructions that are present on both the download page and the release notes for WMF 4.0.

## Description

The **xDSCResourceDesigner** module exposes 6 functions: **New-xDscResourceProperty, New-xDscResource, Update-xDscResource, Test-xDscResource, Test-xDscSchema and Import-xDscSchema**.
These uses of these functions are given below.

## Details

**xDSCResourceDesigner** module exposes the following functions:

* **New-xDscResourceProperty**: For creating a property for the resource
* **New-xDscResource**: for creating the actual resource containing the schema and module skeleton
* **Update-xDscResource**: for updating an existing resource with new properties
* **Test-xDscResource**: for testing whether an existing resource conforms to the rules required by DSC
* **Test-xDscSchema**: for testing whether an existing schema (schema.mof) conforms to the rules required by DSC
* **Import-xDscSchema**: for getting the properties in a schema returned as a hashtable

## Versions

### Unreleased

### 1.13.0.0

* Fix Parameter Blocks to conform to Dsc Style Guidlelines [issue #79](https://github.com/PowerShell/xDSCResourceDesigner/issues/79).
* Fix README.md MarkDownLint Errors and Formatting Issues

### 1.12.0.0

* Fixed `Test-MockSchema` to return True if class name matches resource name when there are multiple embeded classes in the schema mof. [issue #123](https://github.com/PowerShell/xDSCResourceDesigner/issues/73).

### 1.11.0.0

* Added support for Codecov.
* Fix Test-xDscSchema failing to call `Remove-WmiObject` on PowerShell Core.
  The cmdlet `Remove-WmiObject` was removed from the code, instead the
  temporary CIM class is now removed by using mofcomp.exe and the
  preprocessor command [pragma deleteclass](https://msdn.microsoft.com/en-us/library/aa392751(v=vs.85).aspx)
  (issue #67).

### 1.10.0.0

* Converted appveyor.yml to install Pester from PSGallery instead of from Chocolatey.
* Helper function Test-xDscSchemaEncoding now supports PowerShell Core (issue #64).
* Changed README.md encoding to UTF8.

### 1.9.0.0

* Fixed issue where using ValidateSet with type string[] would throw an error

### 1.8.0.0

* Fixed issue where ValueMap on an Array was incorrectly flagged as an error

### 1.7.0.0

* Error message improvements

### 1.6.0.0

* Fixed issue with not being able to import the module twice

### 1.5.0.0

* Fixed issue with adding type twice through Add-Type

### 1.4.0.0

* Added support and tests for -FriendlyName on Update-xDscResource
* Added tests for creating and updating resources
* Minor fixes for Update-xDscResource

### 1.3.0.0

* Minor fixes after PowerShell.org fork merge.

### 1.2.0.0

Merged changes from PowerShell.org fork

* Removed #Requires -RunAsAdministrator.
The commands that require Administrator rights already check for it anyway, and this allows the rest of the module to be used from a normal PowerShell session.
* Added support for Enum types (with associated ValueMap)
* Added support for EmbeddedInstances other than MSFT_Credential and MSFT_KeyValuePair
* Fixed parameter name in Test-xDscResource comment-based help to match actual command definition
* Updated Test-xDscResource to use a process block, since it accepts pipeline input.
* Fixed invalid use of try/catch/finally in Test-MockSchema and Test-DscResourceModule
* Updated code related to Common parameters; now handles all common parameters properly based on command metadata.
* Added very basic tests for Test-xDscResource; these need to be fleshed out quite a bit later.

### 1.1.2

* Ignore -WhatIf and -Confirm internal parameters to suppress false errors when Set-TargetResource declares [CmdletBinding(SupportsShouldProcess=$true)]

### 1.1.1.1

* Metadata updates.

### 1.0.0.0

* Initial release for xDSCResourceDesigner

## Examples

### Create a Sample DSC ADUser Resource

This example creates an ADUser DSC resource.

```powershell
<#
Create a ADUser DSC Resource with following properties
UserName: Name of the ADUser.
This is a  key property for the resource that uniquely identify an instance.
Password: Password of the user.
Can be used to update an existing user password.
DomainAdminstratorCredential: Credential of the Domain Administrator in which user account will be created.
Ensure: Whether an user account should be created or deleted.
This can only take two values: ‘Present’ and ‘Absent’.
#>

$UserName = New-xDscResourceProperty -Name UserName -Type String -Attribute Key
$Password = New-xDscResourceProperty -Name Password -Type PSCredential -Attribute Write
$DomainCredential = New-xDscResourceProperty -Name DomainAdministratorCredential -Type PSCredential -Attribute Write
$Ensure = New-xDscResourceProperty -Name Ensure -Type String -Attribute Write -ValidateSet "Present", "Absent"
#Now create the resource
New-xDscResource -Name Contoso_cADUser -Property $UserName, $Password, $DomainCredential, $Ensure  -Path 'C:\Program Files\WindowsPowerShell\Modules\xActiveDirectory'
```

### Test an Incorrect Resource Definition

This example will use Test-xDscSchema function to check if the resource definition is correct or not

```powershell
<#
Suppose you have the following schema (named buggy.schema.mof):
[ClassVersion("1.0.0.0"), FriendlyName("")]
class Contoso_cADUser : OMI_BaseResource
{
       [Key] String UserName;
       [Write, ValueMap{"Present","Absent"}, Values{"Present","Absent"}] String Ensure;
};
#>
# This reports that the schema is buggy.
Test-xDscSchema -Path .\buggy.schema.mof
<#
Suppose you have the following schema (named buggy.schema.mof):
[ClassVersion("1.0.0.0"), FriendlyName("")]
class Contoso_cADUser : OMI_BaseResource
{
       [Key] String UserName;
       [Write, ValueMap{"Present","Absent"}, Values{"Present","Absent"}] String Ensure;
};
#>

# This reports that the schema is buggy.

Test-xDscSchema -Path .\buggy.schema.mof
```

### Updates an Existing Resource

This example will use Update-xDscResource function to update an already existing resource properties

```powershell
#Assume, you want to add an additional property called LastLogOn on existing Constoso_cADUser resource
$lastLogOn = New-xDscResourceProperty -Name LastLogOn -Type Hashtable -Attribute Read -Description "Returns the user last log on time"
#Update the existing resource
Update-xDscResource -Name 'Contoso_cADUser' -Property $UserName, $Password, $DomainCredential, $Ensure, $lastLogOn -Force
#Assume, you want to add an additional property called LastLogOn on existing Constoso_cADUser resource

$lastLogOn = New-xDscResourceProperty -Name LastLogOn -Type Hashtable -Attribute Read -Description "Returns the user last log on time"

#Update the existing resource
Update-xDscResource -Name 'Contoso_cADUser' -Property $UserName, $Password, $DomainCredential, $Ensure, $lastLogOn -Force
```
