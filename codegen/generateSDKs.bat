call codegen\generateNet ||  goto :error
call codegen\generateJava ||  goto :error

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%
