local Translations = {
    info = {
		['judge']              	         = 'RECHTER',
		['escape_attempt']     	         = 'Je kunt niet ontsnappen. Je taakstraf is verlengd.',
		['remaining_msg']      	         = 'U moet nog ~b~%{remaining}~s~ acties voltooien voordat u uw service kunt beëindigen.',
		['comserv_msg']       	         = '%{user} heeft %{amount} maanden taakstraf gekregen.',
		['comserv_finished']  	         = '%{user} heeft zijn taakstraf volbracht!',
		['press_to_start']               = 'Press ~INPUT_CONTEXT~ to start.',
	},
	command = {
		['start']                        = 'Geef de speler taakstraf',
		['end']                          = 'Beeindig speler taakstraf',
	}
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})

