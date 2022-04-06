$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type === "openGeneral"){
            $('body').fadeIn(500);
        } else if(event.data.type === "balanceHUD") {
            var balance = event.data.balance;
            $('.kx-bank-creditcard-footer-cardholder').html(event.data.player);
            $('.vb-balance-balance').html("$ "+balance);
            $('.kx-bank-tarjetas-mycardcontainer-balance').html("$ "+balance);
            $('.kx-bank-tarjetas-rigthbar-balance').html("$ "+balance);
            $('.kx-bank-myaccount-balance-balance').html("$ "+balance);
            $('.kx-bank-myaccount-faq-balance').html("$ "+balance);
            if (balance.toString().length >= Number(6)) {
                document.getElementById("kx-bank-tarjetas-mycardcontainer-balance").style.fontSize = "28px"
                document.getElementById("kx-bank-tarjetas-rigthbar-balance").style.fontSize = "25px"
                document.getElementById("kx-bank-depositcontainer-balance").style.fontSize = "25px"
                document.getElementById("kx-bank-transferir-container-balance").style.fontSize = "25px"
                document.getElementById("kx-bank-transferir-myaccount-balance").style.fontSize = "25px"
            }
            var playername = event.data.player
            $('.kx-bank-creditcard-cardholder').html(playername);
            var address = event.data.address
            $('.kx-bank-myaccount-info-address').html('<i class="fal fa-map-marker-alt"></i>&nbsp;&nbsp;&nbsp;</i>Dirección:&nbsp;&nbsp;'+address+'</span>');
            var walletid = event.data.playerid
            $('.kx-bank-myaccount-info-walletid').html('<i class="fal fa-wallet"></i>&nbsp;&nbsp;&nbsp;</i>Numero de Cuenta:&nbsp;&nbsp;'+walletid+'</span>');
        } else if (event.data.type === "closeAll"){
            $('body').fadeOut(500);
        }
    });
});

$(document).on('click','#inicio',function(){
    hideall();
    $(".kx-bank-container-inicio").fadeIn(500);
})

$(document).on('click','#mycards',function(){
    hideall();
    $(".kx-bank-bigcontainertarjetas").fadeIn(500);
})

$(document).on('click','#meterpastica',function(){
    hideall();
    $(".kx-bank-bigcontainerdepositar").fadeIn(500);
})

$(document).on('click','#depositar',function(){
    hideall();
    $(".kx-bank-bigcontainerdepositar").fadeIn(500);
})

$(document).on('click','#transfer',function(){
    hideall();
    $(".kx-bank-bigcontainertransfer").fadeIn(500);
})

$(document).on('click','#myaccount',function(){
    hideall();
    $(".kx-bank-bigcontainermyaccount").fadeIn(500);
})

$(document).on('click','#faq',function(){
    hideall();
    $(".kx-bank-bigcontainerfaq").fadeIn(500);
})

$(document).on('click','#closebanking',function(){
    $('body').fadeOut(500);
    $.post('http://kx-bank/NUIFocusOff', JSON.stringify({}));
})

$(document).on('click','#withdraw',function(e){
    e.preventDefault();
    $.post('http://kx-bank/withdraw', JSON.stringify({
        amountw: $("#withdrawnumber").val()
    }));
    $('body').fadeOut(500);
    $.post('http://kx-bank/NUIFocusOff', JSON.stringify({}));
})

$(document).on('click','#depositarpasta',function(e){
    e.preventDefault();
    $.post('http://kx-bank/deposit', JSON.stringify({
        amount: $("#cantidaddepositar").val()
    }));
    $('body').fadeOut(500);
    $.post('http://kx-bank/NUIFocusOff', JSON.stringify({}));
})

$(document).on('click','#transferirpasta',function(e){
    e.preventDefault();
    $.post('http://kx-bank/transfer', JSON.stringify({
        to: $("#iddestinatario").val(),
        amountt: $("#cantidadtransfer").val()
    }));
    $('body').fadeOut(500);
    $.post('http://kx-bank/NUIFocusOff', JSON.stringify({}));
})

function hideall() {
    $(".kx-bank-container-inicio").hide();
    $(".kx-bank-bigcontainertarjetas").hide();
    $(".kx-bank-bigcontainerdepositar").hide();
    $(".kx-bank-bigcontainertransfer").hide();
    $(".kx-bank-bigcontainermyaccount").hide();
    $(".kx-bank-bigcontainerfaq").hide();
}

document.onkeyup = function(data){
    if (data.which == 27){
        $('body').fadeOut(500);
        $.post('http://kx-bank/NUIFocusOff', JSON.stringify({}));
    }
}