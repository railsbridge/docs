**~**  稱為波浪號。在 MacOS X 或是 Linux 系統，這個指令可以定義目前系統使用者的 **家目錄(home directory)** 位置

**\**  當你使用 '跳脫字元' 會用到，來宣告某個 \ 尾端的符號當成字串使用，而不是用在替定功能上，像是 `puts "\""` => 會輸出成 **"**, 如果沒加 \ 就會出現異常

**=**  定義一個變數所使用的符號，建立出該變數，例如： `name= "Veronica"`

**==**  布林(Boolean) 符號，只會輸出二個值： True or False ，例如： ` name == "Veronica" # => True `

**cd (or cd ~)**  將目前位置切換到 **家目錄(home directory)** 的位置

**cd ..**  將目前位置切到現在路徑的上一層

**cd ../../**  切到上二層

**cd** _某路徑_  將目前位置切換到名字為 _某路徑_ 的位置.

**cp** _original.rb copy.rb_  複製 _original.rb_ 這個檔案，並且輸出成 _copy.rb_ 

**ls**  列出目前位置上的所有檔案與資料夾(不含隱藏檔)

**ls** _某路徑_ 列出 _某路徑_ 位置上的所有檔案與資料夾(不含隱藏檔)

**pwd**  顯示從 家目錄(home directory) 為起點，到你目前位置的路徑 (像是 _/home/heidi/tehcodez/Railsbridge_)

**-h (or --help)**  可以列出所有可操作的指令與有用的資訊

**git branch**  顯示你目前所在的 branch 

**git status**  從最後一個 commit 算起，列出所有已更動的檔案列表

**git add -A**  將所有已更動 (含已刪除) 的檔案加入到 Staged Files, 準備 commit 

**git add** _file1.md file2.md file3.md_  將指定的檔名 (_file1.md file2.md file3.md_) 加入到 Staged Files, 準備 commit

**git commit -m** _"你自訂的訊息"_ 將目前所有已加入到 Staged Files 的檔案 提交(Commit) 進 git ，完成儲存動作 (該 commit 的 敘述(description) 就是 _"你自訂的訊息"_ )

**git push origin** <i>某branch</i>  將本地端的 <i>某branch</i> 發布更新到名稱是 'origin' 的遠端程式庫 ( 像是 Github )
