var rgbStart = [139, 195, 74]
var rgbEnd = [183, 28, 28]

$(function () {
    window.addEventListener('message', function (event) {

        let locationn = event.data.locationn;
        let days = event.data.days;

        $("#streetDisplay").text(locationn);
        $("#dateDisplay").text(days);

        if(event.data.wylaczhud == true){
            $('#ui').fadeOut();
          }
           if(event.data.wylaczhud == false){
            $('#ui').fadeIn();
          }
        if(event.data.showhud == true){
            $('.speedometer').fadeIn();
            setProgressSpeed(event.data.speed,'.speed');
          }
          if(event.data.showhud == false){
            $('.speedometer').fadeOut();
          }      
        if (event.data.action == "setTalking") {
            setTalking(event.data.value)
        } else if (event.data.action == "setProximity") {
            setProximity(event.data.value)
        }else if (event.data.action == "updateStatus"){
			updateStatus(event.data.status);
		}else if (event.data.action == "updateHealth"){
			updateHealth(event.data.value);
		}else if (event.data.action == "updateArmor"){
			updateArmor(event.data.value);
        }else if (event.data.action == "showArmor"){
			showArmor();
        }else if (event.data.action == "hideArmor"){
			hideArmor();
               }else if (event.data.action == "showWater"){
            showWater();
        }else if (event.data.action == "hideWater"){
            hideWater();
		}else if (event.data.action == "updateCar"){
			updateCar(event.data.value);
        }else if (event.data.action == "engineSwitch"){
              if(event.data.status){
            $('#engine .bg').css('opacity', '0.7')
            $('#engine .bg').css('background-color', 'rgb(255, 187, 0)')
        }else{
            $('#engine .bg').css('opacity', '0')
            $('#engine .bg').css('background-color', '#141414')
        }
		}else if (event.data.action == "showFuel"){
			showFuel();
				}else if (event.data.action == "showArmor"){
			showArmor();
			}else if (event.data.action == "hideFuel"){
			hideFuel();
		}else if (event.data.action == "hideArmor"){
			hideArmor();
			}else if (event.data.action == "updateFuel"){
			updateFuel(event.data.value);
                }else if (event.data.action == "updateWater"){
            updateWater(event.data.value);
		}else if (event.data.action == "unlocked"){
			unlocked(event.data.value);
        } else if (event.data.action == "toggle") {
            if (event.data.show) {
                $('#ui').show();
            } else {
                $('#ui').hide();
            }
        } else if (event.data.action == "moveHudd") {
            if (event.data.show) {
                $('#huddd').animate({
                    left: "200px"
                })
          
            } else {
                $('#huddd').animate({
                    left: "-100px"
                })
     
            }
        }
    });

});

//XDDDDDDDD


function showFuel(){
	$('#fuel').fadeIn();
	$('#lock').fadeIn();
    $('#engine').fadeIn();
}

function showArmor(){
	$('#armor').fadeIn();
}

function hideArmor(){
	$('#armor').fadeOut();
}


function showWater(){
    $('#water').fadeIn();
}

function hideWater(){
    $('#water').fadeOut();
}


function hideFuel(){
	$('#fuel').fadeOut();
	$('#lock').fadeOut();
    $('#car').fadeOut();
    $('#engine').fadeOut();
}


function updateCarStatus(status){
	var gas = status[0]
	$('#gas .bg').css('height', gas.percent+'%')
	var bgcolor = colourGradient(gas.percent/100, rgbStart, rgbEnd)
	//var bgcolor = colourGradient(0.1, rgbStart, rgbEnd)
	//$('#gas .bg').css('height', '10%')
    $('#gas .bg').css('opacity', '0.7')
	$('#gas .bg').css('background-color', 'rgb(255, 187, 0)')
}

function updateStatusVehicleEngine(status){
	$('#engine .bg').css('opacity', '0.7')
	if (status == "engineon"){
		$('#engine .bg').css('background-color', 'rgb(255, 187, 0)')
		$('#engine').fadeIn();
	}
	if (status == "engineoff"){
		$('#engine .bg').css('background-color', 'rgb(255, 187, 0)')
		$('#engine').fadeIn();
	}
	if (status == "out"){
		$('#engine').hide();
	}
}

function setValue(key, value){
	$('#'+key+' span').html(value)

}

function setJobIcon(value){
	$('#job img').attr('src', 'img/jobs/'+value+'.png')
}

function updateStatus(status){
      $('#hunger .bg').css('height', event.data.hunger + '%');
      $('#water .bg').css('height', event.data.thirst + '%');
      $('#drunk .bg').css('height', event.data.stress + '%');
    if (drunk.percent > 0){
        $('#drunk').fadeIn();
    }else{
        $('#drunk').fadeIn();
    }
}

function updateHealth(value){
	var health = value
	$('#health .bg').css('height', health + '%')
}

function updateArmor(value){
	var armor = value
	$('#armor .bg').css('height', armor + '%')
    $('#armor .bg').css('opacity', '0.77')
    $('#armor .bg').css('background-color', armor + 'rgb(255, 187, 0)')
}

function updateWater(value){
    var wartosc =  value
    console.log(wartosc);
    $('#water .bg').css('height', wartosc + '%')
    $('#water .bg').css('opacity', '0.7')
    $('#water .bg').css('background-color', wartosc + 'rgb(255, 187, 0)')
}


function updateCar(value){
	var car = value
    $('#car .bg').css('opacity', '0.3')
	$('#car .bg').css('height', car + '%')
	if (value > 75) {
        $('#car').hide();   
        $('#car .bg').css('background-color', 'rgb(255, 187, 0)')
		}else if (value < 75 && value > 40 ){
            $('#car').show();
            $('#car .bg').css('opacity', '0.7')
			$('#car .bg').css('background-color', '#d9a600')
		}
		else if (value < 40 && value > 25 ){
            $('#car').show();
            $('#car .bg').css('opacity', '0.9')
			$('#car .bg').css('background-color', '#d6751a')
		}
		else if (value < 25  ){
            $('#car').show();
            $('#car .bg').css('opacity', '0.7')
			$('#car .bg').css('background-color', '#e02b2b')
	}
}

function setProgressSpeed(value, element){
    $('.speed').text(value);
}

function updateFuel(value){
	var fuel = value
	$('#fuel .bg').css('height', fuel + '%')
	if (value < 35) {
        $('#fuel .bg').css('opacity', '0.7')
		$('#fuel .bg').css('background-color', "rgb(255, 187, 0)");
		}else if (value > 35){
            $('#fuel .bg').css('opacity', '0.7')
		$('#fuel .bg').css('background-color', "rgb(255, 187, 0)");
		}
}

function unlocked(value){
	var wartosc = value

	if (value == true) {
        $('#lock .bg').css('opacity', '0')
		$('#lock img').attr('src', 'img/unlocked.png');
        $('#lock .bg').css('background-color', "rgb(255, 187, 0)");
		}else if (value == false){
        $('#lock .bg').css('opacity', '0.7')    
		$('#lock img').attr('src', 'img/locked.png');
        $('#lock .bg').css('background-color', "rgb(255, 187, 0)");
	}
}

// funckcje pod voice

function setProximity(value) {
    var color;
    var speaker;
    if (value == "1") {
        color = "#d9a600";
        speaker = 1;

        
    } else if (value == "2") {
        color = "#d6751a"
        speaker = 2;

    } else if (value == "3") {
        color = "#e02b2b"
        speaker = 3;
    }
     $('.allvoice').css('border-top', '3px solid ' + color); 
    $('#voice img').attr('src', 'img/speaker' + speaker + '.png');
    
}

function setTalking(value){
	if (value){
		$('#voice').css('transform', 'scale(1.15)');
	}else{
		$('#voice').css('transform', 'scale(1.00)')
	}
}