Sometimes during a git remote push (i.e., to github or heroku), the client seems to stall.

    smei@NINOHE ~/Desktop/ruby_on_rails/test_app_2 (master)
    $ git push heroku master
    Warning: Permanently added the RSA host key for IP address '75.101.163.44' to the list of known hosts.
    Counting objects: 63, done.
    Compressing objects: 100% (57/57), done.
    Writing objects: 25% (15/63), 19.30 KiB

When this happens, control-c to end the process, then close the Git Bash window. Open the task manager (right click on the lower menu bar, select Task Manager). Switch tab to "Processes" and click "Image Name" to sort by process name. Scroll down and see if there are any zombie ssh.exe processes. If there are, select them, and hit End Process.

Then, reopen Git Bash. cd to the test_app directory and do a git remote. Make sure the remote you're trying to push to (origin or heroku) is there - if not, re-add it before trying the push again.
