BeforeAll {
    . $PSCommandPath.Replace('.tests.ps1','.ps1')
}
Describe "Stop Log Output" {
    It "Adds Content" {
        $LogPath = "TestDrive:\test_log.txt"
        Stop-Log -LogPath $LogPath -NoExit:$true
        "TestDrive:\test_log.txt" | Should -FileContentMatch "finished"
    }

}