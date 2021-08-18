BeforeAll {
    . $PSCommandPath.Replace('.tests.ps1','.ps1')
}
Describe "Add Log Error" {
    It "Adds Content" {
        $LogFile = "TestDrive:\test_log.txt"
        $LineNumber = "1"
        $Message = "Log Message"
        Add-LogError -LogPath $LogFile -ErrorDesc $Message -LineNumber $LineNumber -ExitGracefully $false
        "TestDrive:\test_log.txt" | Should -FileContentMatch "Log Message"
    }

}