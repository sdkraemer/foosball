  game_generator = {
    add_player_row: function(){
      //todo
      //create form around player drop downs in modal
      //make ajax call to new controller and action
      //have controller action render player_dropdown partial with list of already selected player in form, and passing
      //Player.all

      //game controller action: player_dropdown
      $.ajax({
        url: "<%= games_player_dropdown_path %>",
        data: $("#form-team-generator").serialize(),
        dataType: "html",
        success: function(html){
          $("#div-playerlist").append(html);
        },
        error: function(){
          alert("Unexpected error occurred.")
        }
      });     

    },
    generate_teams: function(){
      $("#form-team-generator").submit();
    }
  }

  game = {
    //submits goal form. Appends 'own goal' checkbox value if checked to Goal's quantity
    score_goal: function(btn){
      var $btn = $(btn);
      var $checkbox = $("#checkbox-owngoal");
      var $form = $btn.closest("form");
      var $goal_quantity = $form.find("input[name=quantity]")


      if( $checkbox.is(":checked") ){
        $goal_quantity.val($checkbox.val())
      }

      $btn.text("Saving...")
      //submit form
      $form.submit()
    }
  }