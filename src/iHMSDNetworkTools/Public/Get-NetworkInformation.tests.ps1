BeforeAll {
    . $PSCommandPath.Replace('.tests.ps1','.ps1')
}
Describe "Get network info" {
    It "Create an Object" {
        Get-NetworkInformation | Should -BeOfType [PSCustomObject]
    }

}