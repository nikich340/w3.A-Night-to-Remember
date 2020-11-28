/* used rmemr's CModUiActionConfirmation as example */
class CNTRPopupRequest extends ConfirmationPopupData {
	var factOnAccept, factOnDecline : string;
	var declineButton : Bool;

	default factOnAccept = "NONE";
	default factOnDecline = "NONE";
	default declineButton = true;

    public function open( title: String, msg: String, declineButton : Bool, optional factOnAccept : String, optional factOnDecline : String )
    {
    	var null : String;

    	if (factOnAccept != null)
    		this.factOnAccept = factOnAccept;
    	if (factOnDecline != null)
    		this.factOnDecline = factOnDecline;

        this.SetMessageTitle(title);
        this.SetMessageText(msg);
        this.BlurBackground = true;
        this.PauseGame = true;
        this.declineButton = declineButton;

        theGame.RequestMenu('PopupMenu', this);
    }

    protected  function DefineDefaultButtons():void
	{	
		AddButtonDef(GetAcceptText(), "enter-gamepad_A", IK_E);
		if (declineButton)
			AddButtonDef(GetDeclineText(), "escape-gamepad_B", IK_Escape);
	}

    protected function OnUserAccept() : void
	{
		super.OnUserAccept();
		if (factOnAccept != "NONE")
			FactsAdd(factOnAccept, 1, -1);
	}
	
	protected function OnUserDecline() : void
	{
		super.OnUserDecline();
		if (factOnDecline != "NONE")
			FactsAdd(factOnDecline, 1, -1);
	}
}

exec function checkConditions() {
	var popup : CNTRPopupRequest;
	var message : String;
	var conditionIdx : int;
	var selectedSpeech : String;
	var selectedText   : String;
	
	conditionIdx = 0;
	FactsSet("ntr_quest_lang_allowed", 0);
	message = "";
	theGame.GetGameLanguageName( selectedSpeech, selectedText );

	if ( selectedSpeech != "EN" ) {
		conditionIdx += 1;
		message += conditionIdx + ") You are using unsupported [" + selectedSpeech + "] lanaguage for speech.<br>It is strongly recommended to change it to [EN], otherwise you will have muted scenes!<br><br>";
	}
	if ( StrFindFirst(GetLocStringByKeyExt("ntr_language_check"), "SUPPORTED") < 0 ) {
		conditionIdx += 1;
		message += conditionIdx + ") You are using unsupported [" + selectedText + "] lanaguage for text.<br>It is strongly recommended to change it to [EN], otherwise you will have missed text in scenes!<br><br>";
	}
	if (FactsQuerySum("q704_orianas_part_done") < 1) {
		conditionIdx += 1;
		message += conditionIdx + ") You did not passed 'Blood Simple' Orianna's quest (Unseen Elder path) in Blood and Wine DLC.<br>It is strongly recommended to play (or watch) it before starting this quest to avoid spoilers!<br><br>";
		popup = new CNTRPopupRequest in thePlayer;
		popup.open("WARNING!", message, true, "ntr_quest_plot_allowed");
	}

	if (message != "") {
		message += "* If you are not ready press ESCAPE and return here next night.<br>";
		message += "* If you want to proceed anyway press OK but you WERE WARNED!<br>";
		popup = new CNTRPopupRequest in thePlayer;
		// for next night
		theGame.SetGameTime( theGame.GetGameTime() + GameTimeCreate(0, 1, 1, 0), true);
		
		popup.open("WARNING!", message, true, "ntr_quest_allowed");
	} else {
		FactsAdd("ntr_quest_allowed", 1);
	}	
}