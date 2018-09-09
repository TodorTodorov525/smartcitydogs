
import "phoenix_html";
import $ from "jquery";
import "slick-carousel";


function myOnLoadCallback() {
    alert("Captcha is OK");
}
$(document).ready(function(){

    $('.change-status').click(function(){
        $(".modal").css("display","block");
    });
    $('.close').click(function(){
        $(".modal").css("display","none");
    });

    $(function(){

        var modal = document.getElementById('myModal');
        //   var span = document.getElementsByClassName("close")[0];
        var id;
        var SelectedType;

        $('.change-status').on('click',function() {
            id = $(this).attr('id');
            console.log("Buttton: "+id);


        });

        $('.asdf-test').on('click',function(){

            SelectedType = $(".select-type option:selected").val()
            console.log(SelectedType);
            console.log("Buttton1: "+id);

            $.ajax({
                method: "GET",
                url: "/signals/"+id+"/update_type",
                data: {
                    "id": id,
                    "signals_types_id": SelectedType
                }
            })

            setTimeout(function() {
                location.reload();
            }, 1000);


        });
    });



    $('#submit-adoption').click(function(){

        $.ajax({
            method: "POST",
            url: "/api/animals/:id/send_email",
            credentials: 'same-origin',
            data: {
                "chip_number": $("#chip_number").text(),
                "user_name": $("#user_name").text(),
                "user_last_name": $("#user_last_name").text(),
                "user_email": $("#user_email").text(),
                "user_phone": $("#user_phone").text(),
                "animal_id": $("#animal_id").text(),
                "user_id": $("#user_id").text()
            },
            success: function (msg) {
                alert("Имейлът ви беше успешно изпратен!");
            },
            error: function (xhr, status) {
                alert("ГРЕШКА!");
            }

        }).done(function(){
            location.reload();
        })
    });

    $('#submit-news').click(function(){
        var editor_content = quill.container.firstChild.innerHTML
        var image = document.getElementById('image').value
        var title = document.getElementById('title').value
        var short_content = document.getElementById('short_content').value
        $.ajax({
            method: "POST",
            url: "/news",
            credentials: 'same-origin',
            data: {
                "news": {
                    "image_url": image,
                    "title": title,
                    "short_content": short_content,
                    "content": editor_content,
                }
            },
            success: function (msg) {
                alert("Новината ви беше успешно създадена!");
            },
            error: function (xhr, status) {
                alert("Неуспешно създаване на новина!");
            }
        }).done(function(){
            location.reload();
        })
    });

    $("#my-signals-link").click(function(){
        $.ajax({
            method: "GET",
            url: "/my_signals"
        }).then(function (data) {
            $(".last-signals-dogs-div").css("display","inline-block");
            $(".last-signals-dogs-div2").css("display","none");
        })

    })
    $("#followed-signals-link").click(function(){
        $.ajax({
            method: "GET",
            url: "/followed_signals",
            data: {
                "followed_signals": 0,
            }
        }).then(function (data) {
            $(".last-signals-dogs-div").css("display","none");
            $(".last-signals-dogs-div2").css("display","inline-block");
        })
    })

    $("#like").click(function () {

        $.ajax({
            method: "GET",
            url: "/api/signals/"+$("#signal-id").text()+"/like"
        }).then(function (data) {
            $("#signal-count").text(data.new_count);

        })
    });

    $('#close-map').click(function() {
        $('#map_container').hide();
    })
    $('.show-map-btn').click(function() {
        $('#map_container').show();
    });



    $('#comment').click(function() {

        $('#comment').hide();
        $('.comment_section').show();
    });

    $('.close_comment').click(function() {

        $('#comment').show();
        $('.comment_section').hide();
    });


    $(".submit_comment").click(function() {
        $.ajax({
            method: "GET",
            url: "/api/signals/:id/comment",
            data: {
                "show-comment": $("#comment-id").val(),
                "show-id": $("#signal-id").text()
            }
        }).done(function(){
            location.reload();
        })
    });


    window.login = function () {
        var params = {email: $("#login-email").val(), password: $("#login-password").val()};
        $.post("/api/users/sign_in", params)
            .done(function (data) {
                if ((data.users_types_id == 4) || (data.users_types_id == 5)) {
                    window.location.href = "municipality/signals";
                }
                else {
                    location.reload();
                }
            })
            .fail(function (text) {
                $("#login-form-errors").text("Невалиден Имейл или Парола!");
            });

    };


    $('.slick').slick({
        slidesToShow: 4,
        slidesToScroll: 1,
        prevArrow: `<button class="slick-prev bg-gray border-0"><i class="fas fa-chevron-left"></i></button>`,
        nextArrow: `<button class="slick-next bg-green border-0 text-white"><i class="fas fa-chevron-right"></i></button>`,
        responsive: [
            {
                breakpoint: 1200,
                settings: {
                    slidesToShow: 4,
                    slidesToScroll: 1,
                    infinite: true,
                }
            },
            {
                breakpoint: 1024,
                settings: {
                    slidesToShow: 3,
                    slidesToScroll: 1,
                    infinite: true,
                }
            },
            {
                breakpoint: 800,
                settings: {
                    slidesToShow: 2,
                    slidesToScroll: 2,
                    infinite: true,
                }
            },
            {
                breakpoint: 480,
                settings: {
                    slidesToShow: 1,
                    slidesToScroll: 1,
                    infinite: true,
                }
            }
        ]
    });

    window.showModalForm = function (event, formId) {

        if ($("#" + formId).is(":visible")) {
            $("#modal-forms-container" ).hide();
        } else {
            $(".modal-form").hide();
            $("#modal-forms-container" ).show();
            $("#" + formId).show();

        }
    };


    $('.close-modal').on('click', function (event) {
        event.preventDefault();
        $("#modal-forms-container" ).hide();
    });

    $(window).scroll(function(e){
        if ( window.location.pathname == '/' ) {
            if ($(document).scrollTop() == 0) {
                $(".top-navbar").addClass("navbar-home");
                $(".modal-form").addClass("shadow-off");
                $(".container-new-signal").addClass("shadow-off");
                $("#top-navbar-container").removeClass("bg-white");
            } else {
                $(".modal-form").removeClass("shadow-off");
                $(".container-new-signal").removeClass("shadow-off");
                $(".container-new-signal").addClass("shadow-on");
                $(".top-navbar").removeClass("navbar-home");
                $("#top-navbar-container").addClass("bg-white");
            }
        }
    });
    $('.navbar-collapse').on('show.bs.collapse', function() {
        $(".top-navbar").removeClass("navbar-home");
    });
    $(".user-signals-tabs").click(function(){
        $('.tabs').hide();
        $(".user-signals-tabs").removeClass("selected");
        $(this).addClass("selected");
        $("#"+$(this).data("show")).show();

    });



    $('.signal-gallery').slick({
        slidesToShow: 2,
        slidesToScroll: 1,
        prevArrow: `<button class="slick-prev bg-gray border-0"><i class="fas fa-chevron-left"></i></button>`,
        nextArrow: `<button class="slick-next bg-green border-0 text-white"><i class="fas fa-chevron-right"></i></button>`,


    });

    $('#view_map').click(function() {
        var cor_a = $('#cor_a').text();
        var cor_b = $('#cor_b').text();
        var mymap = L.map('signal_map').setView([cor_a, cor_b], 16);

        L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw', {
            maxZoom: 20,
            attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, ' +
            '<a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
            'Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
            id: 'mapbox.streets'
        }).addTo(mymap);

        L.marker([cor_a, cor_b]).addTo(mymap);
    });
});
