
powershell
get-variable
$iswindows
$islinux
$PSVersionTable
pwd
$pwd
ls
get-childitem
 get-item env:\
 get-item env:\USER
  printenv USER
hostname
  printenv HOSTNAME

  Get-Help

   get-help get-command

  get-command

  get-command | measure

  get-command -Verb get

  get-command -Verb get | sort

  get-command -name Get-Module 

  get-command -Module Microsoft.Powershell.management

  (get-command -name Get-Module).Parameters


  get-module -ListAvailable

   get-module -name Microsoft.Powershell.management


   Get-Process

   new-item -ItemType Directory -Name "test" 

   ls

   cd test

   new-item -ItemType File -Name "testfile" -Value "Ritesh Modi"

   ls

   get-childitem

   cat testfile

   get-content testfile

   remove-item testfile

   cd ..

   sudo rm test

   remove-item test


























$a = 10

if($a -eq 10){
"It is 10"
} else {
 "it is not 10"
}

