local Translations = {
    info = {
		['judge']              	         = 'JUDGE',
		['escape_attempt']     	         = 'You can not escape. Your community service has been extended with %{amount}.',
		['remaining_msg']      	         = 'You have ~b~%{remaining}~s~ more actions to complete before you can finish your service.',
		['comserv_msg']       	         = '%{user} has been sentecned in %{amount} months of community service.',
		['comserv_finished']  	         = '%{user} has finished his community service!',
		['press_to_start']               = 'Press ~INPUT_CONTEXT~ to start.',
	},
	command = {
		['start']                        = 'Give player community service',
		['end']                          = 'End player community service',
	},
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})

