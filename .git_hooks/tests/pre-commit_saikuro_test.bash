#!/usr/bin/env bash

USE_HOOKS="saikuro"
. test_helper

test_saikuro(){
   local code="
     class User
       # complexity: 10
       def warning_method
         if(a); if(a); if(a); nil; end; end; end;
         if(a); if(a); if(a); nil; end; end; end;
         if(a); if(a); if(a); nil; end; end; end;
       end

       # complexity: 13
       def error_method
         if(a); if(a); if(a); nil; end; end; end;
         if(a); if(a); if(a); nil; end; end; end;
         if(a); if(a); if(a); nil; end; end; end;
         if(a); if(a); if(a); nil; end; end; end;
       end
     end "

    local warning
    echo "$code" > ./user.rb
    git add ./user.rb
    warning=$(git commit -m "spaghetti code" 2>&1 1>/dev/null)
    assertTrue "echo '${warning}' | grep 'Saikuro error: ./user.rb: User#error_method has complexity 13'"
    assertTrue "echo '${warning}' | grep 'Saikuro warning: ./user.rb: User#warning_method has complexity 10'"
}

. ./shunit2