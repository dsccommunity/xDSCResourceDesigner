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