window["channel: "+game.id]=pusher.subscribe("game_channel_number_"+game.id),window["channel: "+game.id].bind("game_data_for_"+game.id,function(data){if("t"==data.message[0]&&location.reload(),"c"==data.message[0]&&location.reload(),"coup"===JSON.parse(data.message).action&&JSON.parse(data.message).opponent==current_user.nickname&&(document.getElementById("reactToCoup").className=""),"assassin"===JSON.parse(data.message).action&&JSON.parse(data.message).opponent==current_user.nickname&&(document.getElementById("reactToAssassin").className="",document.getElementById("claimContessa").className=""),"theft"===JSON.parse(data.message).action&&JSON.parse(data.message).opponent==current_user.nickname&&(document.getElementById("reactToTheft").className=""),"foreign aid"===JSON.parse(data.message).action&&JSON.parse(data.message).opponent!=current_user.nickname&&(document.getElementById("reactToForeignAid").className=""),"fail"===JSON.parse(data.message).result&&JSON.parse(data.message).player===current_user.nickname&&(document.getElementById("reactToFailedChallenge").className="",document.getElementById("reactToTax").className="hidden",document.getElementById("reactToTheft").className="hidden",document.getElementById("reactToExchange").className="hidden",document.getElementById("reactToBlockTheftCaptin").className="hidden",document.getElementById("reactToBlockTheftAmbassador").className="hidden",document.getElementById("reactToBlockContessa").className="hidden",document.getElementById("reactToForeignAid").className="hidden"),"succeede"===JSON.parse(data.message).result&&JSON.parse(data.message).player===current_user.nickname&&(document.getElementById("reactToSuccessfulChallenge").className=""),"tax"===JSON.parse(data.message).action&&JSON.parse(data.message).opponent!=current_user.nickname&&(document.getElementById("reactToTax").className=""),"block"===JSON.parse(data.message).action){var infoString=JSON.parse(data.message).opponent+" blocks with "+JSON.parse(data.message).card;document.getElementById("displayBlockInfo").innerHTML=infoString}"block"===JSON.parse(data.message).action&&JSON.parse(data.message).opponent!=current_user.nickname&&"Contessa"==JSON.parse(data.message).card&&(document.getElementById("reactToBlockContessa").className=""),"block"===JSON.parse(data.message).action&&JSON.parse(data.message).opponent!=current_user.nickname&&"Duke"==JSON.parse(data.message).card&&(document.getElementById("reactToBlockForeignAid").className=""),"block"===JSON.parse(data.message).action&&JSON.parse(data.message).opponent!=current_user.nickname&&"Captin"==JSON.parse(data.message).card&&(document.getElementById("reactToBlockTheftCaptin").className=""),"block"===JSON.parse(data.message).action&&JSON.parse(data.message).opponent!=current_user.nickname&&"Ambassador"==JSON.parse(data.message).card&&(document.getElementById("reactToBlockTheftAmbassador").className=""),"exchange"===JSON.parse(data.message).action&&JSON.parse(data.message).opponent!=current_user.nickname&&(document.getElementById("reactToExchange").className=""),console.log(data.message)});