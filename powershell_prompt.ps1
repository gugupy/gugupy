function prompt {

  $ESC = [char]27
  $RED = "$ESC[91m"
  $NC = "$ESC[00m"

  $prompt_ = ""

  # Current Directory
  if ($(Get-Location).Path -eq $env:USERPROFILE) {
    $prompt_ += "📂 ~"  
  } else {
    $path_c = $(Get-Location).Path.Split('\')[-1]
    $prompt_ += "📂 " + $path_c 
  }

  # Identify Git Repo
  $branch = (git branch) 2> ~/.error.log

  if ($null -ne $branch) {
    $prompt_ += "$RED git$NC($(git branch --show-current))"
  }

  # Localtime
  $local_time = Get-Date -Format "HH:mm:ss"
  $prompt_ += " [$local_time] "

  # Battery Percentage Warning
  $bat_per = (Get-CimInstance -ClassName Win32_Battery).EstimatedChargeRemaining
  $bat_status = (Get-WmiObject -Class Win32_Battery).BatteryStatus

  if ($bat_status -eq 2) {
    $prompt_ += "[⚡$bat_per%]"
  } elseif ($bat_per -lt 30){
      $prompt_ += "[🪫 $bat_per%]"
  }

  $prompt_ += "# "
  $prompt_ 
}
