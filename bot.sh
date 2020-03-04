#!/bin/bash
#!/user/bin/perl

. bot.properties
input=".bot.cfg"
echo "Starting session: $(date "+[%y:%m:%d %T]")">$log 
echo "NICK $nick" > $input 
echo "USER $user" >> $input
#echo "JOIN #$channel" >> $input
#echo "JOIN #$channelb" >> $input
#echo "JOIN #$channelc" >> $input
#echo "JOIN #$channeld" >> $input

#new=$(echo $res^^)
tail -f $input | openssl s_client -connect $server:6697 | while read res
do
  # log the session
  echo "$(date "+[%y-%m-%d %T]")$res" >> $log
  # do things when you see output
  case "$res" in
    # respond to ping requests from the server
    PING*)
      echo "$res" | sed "s/I/O/" >> $input 
    ;;
    *"This nickname is regist"*) 
     echo "PRIVMSG NICKSERV :IDENTIFY $password" >> $input 
    ;;
    *"You are now logged in as $nick"*)
     echo "JOIN $channel" >> $input
     echo "JOIN $channelb" >> $input
     echo "JOIN $channelc" >> $input
     echo "JOIN $channeld" >> $input
    	;;
################### CONFIGURE THIS
	*"@help"*)
	 from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
    	 echo "PRIVMSG $from :Commands for $nick are as follow: @hello, @lonely, @megatron, @fistbump, @cookies, @8ball, @idea, @satisfy. Use prefix @ always.. " >> $input
   	;;
	*"@hello"*)
	 who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/")
	 from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
    	 echo "PRIVMSG $from :Hello $who, i am $nick. Your personal health care companion" >> $input
   	;;
	*"@lonely"*)
	 from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
    	 echo "PRIVMSG $from :A hug will make you feel better" >> $input
	 echo "PRIVMSG $from :ACTION hugs $who tightly ." >> $input
	;;
	*"@megatron"*)
	 from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
	 echo "PRIVMSG $from :Megatron is my dad" >> $input
	;;
	*"@fistbump"*)
	 who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/")
	 from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
	echo "PRIVMSG $from :ACTION fist bumbs $who saying Bada-lada-la.. ." >> $input

	;;
	*"@satisfy"*)
	 from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
	 echo "PRIVMSG $from :Are you satisfied with your care?" >> $input
	;;
	*"EvilBot need viagra... to stay online."*)
	 from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
	 echo "PRIVMSG $from :You are right daddy meg" >> $input
	;;
	*"@cookies"*)
	 from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
	 echo "PRIVMSG $from :I dont have cookies, but my dad have it." >> $input
	 echo "PRIVMSG $from :-megatron cookies" >> $input
	;;
############# Make bot say the msg u type or make it do an action
	*"@say"*) 
	 who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/") 
	 msg=$(echo "$res" | sed "s/^.*://") 
	 bts=$(echo "$msg" | sed "s/[^ ]* //")
	 if [ "$who" = "Shadow_Lobster" ]
	  then echo "PRIVMSG $channel :$bts" >> $input
	 elif [ "$who" = "shadowlobster" ]
	  then echo "PRIVMSG $channel :$bts" >> $input
	 elif [ "$who" = "TripleZer0" ]
	  then echo "PRIVMSG $channel :$bts" >> $input
	 elif [ "$who" = "PatientZer0" ]
	  then echo "PRIVMSG $channel :$bts" >> $input
	 else echo "PRIVMSG $who Access denied" >> $input
	 fi
	;;
	*"@action"*) 
	 who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/") 
	 msg=$(echo "$res" | sed "s/^.*://") 
	 bts=$(echo "$msg" | sed "s/[^ ]* //")
	 if [ "$who" = "Shadow_Lobster" ]
	  then echo "PRIVMSG $channel :ACTION $bts" >> $input
	 elif [ "$who" = "shadowlobster" ]
	  then echo "PRIVMSG $channel :ACTION $bts" >> $input
	 elif [ "$who" = "TripleZer0" ]
	  then echo "PRIVMSG $channel :ACTION $bts" >> $input
	 elif [ "$who" = "PatientZer0" ]
	  then echo "PRIVMSG $channel :ACTION $bts" >> $input
	 else echo "PRIVMSG $who Access denied bitch" >> $input
	 fi
	;;
#### randomises yes or no questions
	*"@8ball"*)
	 from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
	 ans=(
	    "Signs point to yes."
	    "Yes."
	    "Reply hazy, try again."
	    "Without a doubt."
	    "My sources say no."
	    "As I see it, yes."
	    "Concentrate and ask again."
	    "It is decidedly so."
	    "Better not tell you now."
	    "Very doubtful."
	    "Yes - definitely."
	    "It is certain."
	    "Cannot predict now."
	    "Most likely."
	    "Ask again later."
	    "My reply is no."
	    "Don't count on it."
	    "No."
	    "Very unlikely."
	    "No - don't even think about it."
	 )
	 echo "PRIVMSG $from :${ans[ $(( $RANDOM % ${#ans[@]} )) ]}" >> $input
	;;
####to quit bot without closing terminal. run saver.sh to reboot bot instead of quit
	*"@quit"*)
	 who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/") 
	 if [ "$who" = "Shadow_Lobster" ]
	  then echo "PRIVMSG $channel :restarting in 3..." >> $input
	       echo "PRIVMSG $channel :2.." >> $input
	       echo "PRIVMSG $channel :1" >> $input
	       echo "QUIT" >> $input
	 elif [ "$who" = "shadowlobster" ]
	  then echo "PRIVMSG $channel :restarting in 3.." >> $input
	       echo "PRIVMSG $channel :2.." >> $input
	       echo "PRIVMSG $channel :1" >> $input
	       echo "QUIt" >> $input
	 elif [ "$who" = "TripleZer0" ]
	  then echo "PRIVMSG $channel :restarting in 3.." >> $input
	       echo "PRIVMSG $channel :2.." >> $input
	       echo "PRIVMSG $channel :1" >> $input
	       echo "QUIt" >> $input
	 elif [ "$who" = "PatientZer0" ]
	  then echo "PRIVMSG $channel :restarting in 3.." >> $input
	       echo "PRIVMSG $channel :2.." >> $input
	       echo "PRIVMSG $channel :1" >> $input
	       echo "QUIt" >> $input
	 else 
	  echo "PRIVMSG $who Access denied bitch" >> $input
	 fi
	;;
#### sent idea to a idea.txt file
	*"@idea"*)
	 who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/") 
	 msg=$(echo "$res" | sed "s/^.*://") 
	 bts=$(echo "$msg" | sed "s/[^ ]* //")
	 from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
	 time=$(date +"%d_%m_%Y %T")
	 echo "$time: idea from $who in $from :$bts" >> $idea
	 echo "PRIVMSG $from :Your idea has been sent, $who" >> $input
	;;
##### rename the log to save it before rebooting the bot
   	*"@logup"*)
    	 who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/")
   	 now=$(date +"%m-%d-%y")
   	 mane="log_"$now".txt"
	 if [ "$who" = "Shadow_Lobster" ]
	  then mv log.txt $mane 
	       echo "PRIVMSG $channel :updated logs" >> $input
	 elif [ "$who" = "shadowlobster" ]
	  then mv log.txt $mane
	       echo "PRIVMSG $channel :updated logs" >> $input
	 else
	  echo "PRIVMSG $who :Access denied bitch" >> $input
	 fi
    	;;
	*"@join"*)
### join any channel without rebooting
	 who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/") 
	 msg=$(echo "$res" | sed "s/^.*://") 
	 bts=$(echo "$msg" | sed "s/[^ ]* //")
	 if [ "$who" = "Shadow_Lobster" ]
	  then echo "JOIN #"$bts"" >> $input
	 elif [ "$who" = "shadowlobster" ]
	  then echo "JOIN #"$bts"" >> $input
	 elif [ "$who" = "TripleZer0" ]
	  then echo "JOIN #"$bts"" >> $input
	 else
	  echo "PRIVMSG $who :Bitch fuck off you dont have the access" >> $input
	 fi
	;;
### leave any channel without reboot
	*"@part"*)
	 who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/") 
	 msg=$(echo "$res" | sed "s/^.*://") 
	 bts=$(echo "$msg" | sed "s/[^ ]* //")
	 if [ "$who" = "Shadow_Lobster" ]
	  then echo "PART #"$bts"" >> $input
	 elif [ "$who" = "shadowlobster" ]
	  then echo "PART #"$bts"" >> $input
	 else
	  echo "PRIVMSG $who :Bitch fuck off you dont have the access" >> $input
	 fi
	;;
#### nick change for bot
	*"@nick"*)
	 who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/") 
	 msg=$(echo "$res" | sed "s/^.*://") 
	 bts=$(echo "$msg" | sed "s/[^ ]* //")
	 if [ "$who" = "Shadow_Lobster" ]
	  then echo "NICK "$bts"" >> $input
	 elif [ "$who" = "shadowlobster" ]
	  then echo "NICK "$bts"" >> $input
	 else
	  echo "PRIVMSG $who :oopsie access card not found" >> $input
	 fi
	;;
### private msg to anyone or anything or any lobby
	*"@pm"*)
	 who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/") 
	 msg=$(echo "$res" | sed "s/^.*://") 
	 bts=$(echo "$msg" | sed "s/[^ ]* //")
	 if [ "$who" = "Shadow_Lobster" ]
	  then echo "$msg" >> $input
	 elif [ "$who" = "shadowlobster" ]
	  then echo  "$msg" >> $input
	 else
	  echo "PRIVMSG $who :no access lol" >> $input
	 fi
	;;
##### sents private messeges recieved by bot to specified user
	*"PRIVMSG $nick"*)
	 who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/") 
	 msg=$(echo "$res" | sed "s/^.*://") 
	 bts=$(echo "$msg" | sed "s/[^ ]* //")
	 if [ "$who" = "Shadow_Lobster" ]
	  then echo "$msg" >> $input
	 elif [ "$who" = "shadowlobster" ]
	  then echo "$msg" >> $input
	 else
	  echo "PRIVMSG Shadow_Lobster : "$who" ":""$msg"" >> $input
	 fi
	;;
	*"@calc"*)
	 who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/") 
	 msg=$(echo "$res" | sed "s/^.*://") 
	 bts=$(echo "$msg" | sed "s/[^ ]* //")
	 from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
	 num=$(echo "$bts" | sed 's/[^0-9]*//g')
	 op=$(echo "$bts" | sed -e 's/[^0-9]\(.*\)[^0-9]/\1/')
	 echo "PRIVMSG $channelc : $num $op" >> $input
# calulator operations 
	 case $op in
	   +)ret=`echo $a + $b | bc`  
	  ;; 
	   -)ret=`echo $a - $b | bc` 
	  ;; 
	   x)ret=`echo $a \* $b | bc` 
	  ;; 
	   /)ret=`echo "scale=2; $a / $b" | bc` 
	  ;; 
	  esac
	  echo "PRIVMSG $from Result is $ret" >> $input
	;;
#### Test and Junk stuff
#	*"Shadow_Lobster"*)
#	 who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/")
#	 from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
#	 echo "PRIVMSG $from :Shadow_Lobster is watching a movie in his pc now. Please wait $who">> $input

#	;;
############ Join welcome msg
#    *JOIN*) 
#      who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/")
#      from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
#      if [ "$who" = "TripleZer0" ]
#      then echo "PRIVMSG $from Oh dear lord, Bless me with your codes" >> $input
#      elif [ "$who" = "PatientZer0" ]
#      then echo "PRIVMSG $from Oh dear lord, Bless me with your codes" >> $input
#      elif [ "$who" = "Megatron" ]
#      then echo "PRIVMSG $from Who's My Mom Daddy???" >> $input
#      elif [ "$who" = "Shadow_Lobster" ]
#      then echo "PRIVMSG $from Hmm you might be the one who created me but you copied the code lobster boi" >> $input
#      elif [ "$who" = "shadowlobster" ]
#      then echo "PRIVMSG $from Hmm you might be the one who created me but you copied the code lobster boi" >> $input
##	else echo "PRIVMSG $from sTaY eViL $who" >>$input
#      fi
#     ;;
################### ^^^^^^^^^^^^^^

    # run when a message is seen
    *PRIVMSG*)
      echo "$res"
      who=$(echo "$res" | perl -pe "s/:(.*)\!.*@.*/\1/")
      from=$(echo "$res" | perl -pe "s/.*PRIVMSG (.*[#]?([a-zA-Z]|\-)*) :.*/\1/")
      # "#" would mean it's a channel
      if [ "$(echo "$from" | grep '#')" ]
      then
        test "$(echo "$res" | grep ":$nick:")" || continue
        will=$(echo "$res" | perl -pe "s/.*:$nick:(.*)/\1/")
      else
        will=$(echo "$res" | perl -pe "s/.*$nick :(.*)/\1/")
        from=$who
      fi
      will=$(echo "$will" | perl -pe "s/^ //")
      com=$(echo "$will" | cut -d " " -f1)
      if [ -z "$(ls modules/ | grep -i -- "$com")" ] || [ -z "$com" ]
      then
       echo "TEST SHIT" 
##./modules/help.sh $who $from >> $input
        continue
      fi
      echo "TEST SHIT"
## ./modules/$com.sh $who $from $(echo "$will" | cut -d " " -f2-99) >> $input
    ;;
    *)
      echo "$res"
    ;;
  esac
done
