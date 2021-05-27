Add-Type -assembly System.Windows.Forms
$Header = "SESSIONNAME", "USERNAME", "ID", "STATUS"
$dlgForm = New-Object System.Windows.Forms.Form
$dlgForm.Text ='Session Connect'
$dlgForm.Width = 400
$dlgForm.AutoSize = $true
$dlgBttn = New-Object System.Windows.Forms.Button
$dlgBttn.Text = 'Control'
$dlgBttn.Location = New-Object System.Drawing.Point(15,10)
$dlgForm.Controls.Add($dlgBttn)
$dlgList = New-Object System.Windows.Forms.ListView
$dlgList.Location = New-Object System.Drawing.Point(0,50)
$dlgList.Width = $dlgForm.ClientRectangle.Width
$dlgList.Height = $dlgForm.ClientRectangle.Height
$dlgList.Anchor = "Top, Left, Right, Bottom"
$dlgList.MultiSelect = $False
$dlgList.View = 'Details'
$dlgList.FullRowSelect = 1;
$dlgList.GridLines = 1
$dlgList.Scrollable = 1
$dlgForm.Controls.add($dlgList)
# Add columns to the ListView
foreach ($column in $Header){
$dlgList.Columns.Add($column) | Out-Null
}
$(qwinsta.exe | findstr "Active") -replace "^[\s>]" , "" -replace "\s+" , "," | ConvertFrom-Csv -Header $Header | ForEach-Object {
$dlgListItem = New-Object System.Windows.Forms.ListViewItem($_.SESSIONNAME)
$dlgListItem.Subitems.Add($_.USERNAME) | Out-Null
$dlgListItem.Subitems.Add($_.ID) | Out-Null
$dlgListItem.Subitems.Add($_.STATUS) | Out-Null
$dlgList.Items.Add($dlgListItem) | Out-Null
}
$dlgBttn.Add_Click(
{
$SelectedItem = $dlgList.SelectedItems[0]
if ($SelectedItem -eq $null){
[System.Windows.Forms.MessageBox]::Show("Выберите сессию для подключения")
}else{
$session_id = $SelectedItem.subitems[2].text
$(mstsc /shadow:$session_id /control)
#[System.Windows.Forms.MessageBox]::Show($session_id)
}
}
)
$dlgForm.ShowDialog()
