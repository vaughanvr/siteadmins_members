# Copyright 2020  (Vaughan) VV
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation,  version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# It Creates a list of members and their mailbox sizes in temp folder 
# this can only be run in powershell on a computer connected to a Domain Controller.
# To run at the prompt type ./siteadmins.ps1 and hit enter.

PROCESS

{
# Creates a CSV list of members from group site admins pulled from the domain controller 





	Import-Module ActiveDirectory 


	$groupmembers = Get-ADGroup -Filter "Name -like 'SITEADMINS*'"  | foreach  { Get-ADGroupMember -Identity $_.SamAccountName}  |select -exp samaccountname
	
# replace the OU1,OU2,DC1 & DC2 with your local equivalent Organizational Unit and Domain Controller 

	$users = Get-ADUser -filter *  -SearchBase "OU=OU1,OU=OU2,DC=DC1,DC=DC2" |select -exp samaccountname


 $list = ForEach ($user in $users) {
    If ($groupmembers -contains $user) {
    $name=$user.name
 
			   Write-output  "$user"
 } 
   
 } 
	
	
	

  $list |  Get-AdUser  -Properties * | Select SamAccountName,Name,Mail,StreetAddress,City,st,Country,displayname, samaccountname, lastlogondate , Canonicalname ,enabled,Mail | Export-Csv -path "C:\Temp\dcadminList.csv" -Encoding UTF8


	
}
