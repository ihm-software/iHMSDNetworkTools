BeforeAll {
    . $PSCommandPath.Replace('.tests.ps1','.ps1')
}
Describe "Get network info" {
    It "Create an Object" {
        Invoke-Speedtest -testcount 1 -size 500 | Should -BeOfType [PSCustomObject]
    }

}