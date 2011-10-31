$ ->
  $("#logo").html("")
  paper = Raphael("logo", 184, 100);
  paper.text(0,34,'KISS').attr({fill:"90-#000:0-#666",font:"80px Myriad","font-weight":"bold","text-anchor":"start"});
  paper.text(158,34,'r').attr({fill:"90-#33a:0-#ccf",font:"80px Myriad","font-weight":"bold","text-anchor":"start"});
