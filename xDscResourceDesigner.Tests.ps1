#requires -RunAsAdministrator
# Test-xDscResource requires administrator privileges, so we may as well enforce that here.

end
{
    Remove-Module [x]DscResourceDesigner -Force
    Import-Module $PSScriptRoot\xDscResourceDesigner.psd1 -ErrorAction Stop

    Describe Test-xDscResource {
        Context 'A module with a psm1 file but no matching schema.mof' {
            Setup -Dir TestResource
            Setup -File TestResource\TestResource.psm1 -Content (Get-TestDscResourceModuleContent)

            It 'Should fail the test' {
                $result = Test-xDscResource -Name $TestDrive\TestResource
                $result | Should Be $false
            }
        }

        Context 'A module with a schema.mof file but no psm1 file' {
            Setup -Dir TestResource
            Setup -File TestResource\TestResource.schema.mof -Content (Get-TestDscResourceSchemaContent)

            It 'Should fail the test' {
                $result = Test-xDscResource -Name $TestDrive\TestResource
                $result | Should Be $false
            }
        }

        Context 'A resource with both required files, valid contents' {
            Setup -Dir TestResource
            Setup -File TestResource\TestResource.schema.mof -Content (Get-TestDscResourceSchemaContent)
            Setup -File TestResource\TestResource.psm1 -Content (Get-TestDscResourceModuleContent)

            It 'Should pass the test' {
                $result = Test-xDscResource -Name $TestDrive\TestResource
                $result | Should Be $true
            }
        }
    }

    Describe New-xDscResourceProperty {
        $hash = @{ Result = $null }

        It 'Allows the use of the ValidateSet parameter' {
            $scriptBlock = {
                $hash.Result = New-xDscResourceProperty  -Name Ensure  -Type String  -Attribute Required  -ValidateSet 'Present','Absent'
            }

            $scriptBlock | Should Not Throw
            
            $hash.Result.Values.Count | Should Be 2
            $hash.Result.Values[0]    | Should Be 'Present'
            $hash.Result.Values[1]    | Should Be 'Absent'
            
            $hash.Result.ValueMap.Count | Should Be 2
            $hash.Result.ValueMap[0]    | Should Be 'Present'
            $hash.Result.ValueMap[1]    | Should Be 'Absent'
        }

        It 'Allows the use of the ValueMap and Values parameters' {
            $scriptBlock = {
                $hash.Result = New-xDscResourceProperty  -Name Ensure  -Type String  -Attribute Required  -Values 'Present','Absent' -ValueMap 'Present','Absent'
            }
            
            $scriptBlock | Should Not Throw
            
            $hash.Result.Values.Count | Should Be 2
            $hash.Result.Values[0]    | Should Be 'Present'
            $hash.Result.Values[1]    | Should Be 'Absent'
            
            $hash.Result.ValueMap.Count | Should Be 2
            $hash.Result.ValueMap[0]    | Should Be 'Present'
            $hash.Result.ValueMap[1]    | Should Be 'Absent'
        }

        It 'Does not allow ValidateSet and Values / ValueMap to be used together' {
            $scriptBlock = {
                New-xDscResourceProperty  -Name Ensure `
                                          -Type String `
                                          -Attribute Required `
                                          -Values 'Present','Absent' `
                                          -ValueMap 'Present','Absent' `
                                          -ValidateSet 'Present', 'Absent'
            }

            $scriptBlock | Should Throw 'Parameter set cannot be resolved'
        }
    }

    Describe 'Creating and updating resources' {
        Context 'Creating and updating a DSC Resource' {
            Setup -Dir TestResource
            $ResourceProperties = $( 
                New-xDscResourceProperty -Name KeyProperty -Type String -Attribute Key
                New-xDscResourceProperty -Name RequiredProperty -Type String -Attribute Required
                New-xDscResourceProperty -Name WriteProperty -Type String -Attribute Write
                New-xDscResourceProperty -Name ReadProperty -Type String -Attribute Read
            )
            New-xDscResource -Name TestResource -FriendlyName cTestResource -Path $TestDrive -Property $ResourceProperties -Force
            # Removing empty lines in module since Update-xDSCResouce adds new empty lines, this has been reported as an issue.
            $NewSchemaContent = Get-Content -Path "$TestDrive\DSCResources\TestResource\TestResource.schema.mof" -Raw
            $NewModuleContent = -join(Get-Content -Path "$TestDrive\DSCResources\TestResource\TestResource.psm1") -notmatch '^\s*$'
            Update-xDscResource -Path "$TestDrive\DSCResources\TestResource" -Property $ResourceProperties -Force
            $UpdatedSchemaContent = Get-Content -Path "$TestDrive\DSCResources\TestResource\TestResource.schema.mof" -Raw
            $UpdatedModuleContent = -join(Get-Content -Path "$TestDrive\DSCResources\TestResource\TestResource.psm1") -notmatch '^\s*$'
            It 'Creates a valid module script and schema' {
                Test-xDscResource -Name "$TestDrive\DSCResources\TestResource" | Should Be $true
            }
            It 'Updated Module Script and Schema should be equal to original' {
                $NewSchemaContent -eq $UpdatedSchemaContent | Should Be $true
                $NewModuleContent -eq $UpdatedModuleContent | Should Be $true
            }
        }
    }
}

begin
{
    function Get-TestDscResourceModuleContent
    {
        $content = @'
            function Get-TargetResource
            {
                [OutputType([hashtable])]
                [CmdletBinding()]
                param (
                    [Parameter(Mandatory)]
                    [string] $KeyProperty,

                    [Parameter(Mandatory)]
                    [string] $RequiredProperty
                )

                return @{
                    KeyProperty      = $KeyProperty
                    RequiredProperty = 'Required Property'
                    WriteProperty    = 'Write Property'
                    ReadProperty     = 'Read Property'
                }
            }

            function Set-TargetResource
            {
                [CmdletBinding()]
                param (
                    [Parameter(Mandatory)]
                    [string] $KeyProperty,

                    [Parameter(Mandatory)]
                    [string] $RequiredProperty,

                    [string] $WriteProperty
                )
            }

            function Test-TargetResource
            {
                [OutputType([bool])]
                [CmdletBinding()]
                param (
                    [Parameter(Mandatory)]
                    [string] $KeyProperty,

                    [Parameter(Mandatory)]
                    [string] $RequiredProperty,

                    [string] $WriteProperty
                )

                return $false
            }
'@

        return $content
    }

    function Get-TestDscResourceSchemaContent
    {
        $content = @'
[ClassVersion("1.0.0"), FriendlyName("cTestResource")]
class TestResource : OMI_BaseResource
{
    [Key] string KeyProperty;
    [required] string RequiredProperty;
    [write] string WriteProperty;
    [read] string ReadProperty;
};
'@

        return $content
    }
}