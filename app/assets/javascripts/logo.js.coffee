$ ->
  $("#logo").html("")
  paper = Raphael("logo", 384, 100);
  paper.text(0,34,'Drop').attr({fill:"90-#000:0-#666",font:"60px myriad-pro","font-weight":"bold","text-anchor":"start"});
  paper.text(135,34,'Lamp').attr({fill:"90-#000:0-#f55",font:"60px myriad-pro","font-weight":"bold","text-anchor":"start"});
