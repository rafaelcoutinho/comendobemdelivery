/*
	Copyright (c) 2004-2009, The Dojo Foundation All Rights Reserved.
	Available via Academic Free License >= 2.1 OR the modified BSD license.
	see: http://dojotoolkit.org/license for details
*/


if(!dojo._hasResource["com.copacabana.TimeRangeChooser"]){ //_hasResource checks added by build. Do not use _hasResource directly in your code.
dojo._hasResource["com.copacabana.TimeRangeChooser"] = true;
dojo.provide("com.copacabana.TimeRangeChooser");
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require("dijit.form.Form");
dojo.require("dijit.form.Button");
dojo.require("dijit.form.ValidationTextBox");
dojo.require("dijit.form.DateTextBox");
dojo.require("dijit.form.CheckBox");
dojo.require("com.copacabana.util");
dojo.require("dijit.InlineEditBox");
dojo.require("dijit.form.Textarea");


//I18N
dojo.require("dojo.string");
dojo.require("dojo.i18n");
 
dojo.requireLocalization("com.copacabana", "TimeRangeChooserStrings", null, "ROOT,pt");

dojo.declare("com.copacabana.TimeRangeChooser", [
		dijit._Widget, dijit._Templated ], {

	templateString:"<div>\r\n<span class=\"horarios\" style=\"float:left; font-weight: bold;display: inline-block;width: 100px;\">${dayOfWeekLabel} </span><div dojoAttachPoint=\"openStatusChooser\"></div> \r\n<div dojoAttachPoint=\"timeSection\">\r\n<span  style=\"font-weight: bold;display: inline-block;width: 105px;\"></span><span class=\"timeSelect\"> das <span dojoAttachPoint=\"openTimeSection\"></span> at&eacute; as <span dojoAttachPoint=\"closeTimeSection\"></span> <button class=\"addSecondTurnBtn\" baseClass=\"orangeButton\" dojoType=\"dijit.form.Button\" dojoAttachPoint=\"addSecondTurnBtn\" dojoAttachEvent=\"onclick:clicked\">+ turno</button></span>\t  \r\n<div dojoAttachPoint=\"secondTurnSection\" style=\"display: none\">\r\n<span class=\"horarios\" style=\"display: inline-block;width: 100px;\">Segundo turno</span> <span class=\"timeSelect\">das <span dojoAttachPoint=\"secondTurnStartSection\"></span> at&eacute; &agrave;s <span dojoAttachPoint=\"secondTurnCloseSection\"></span>\r\n<button class=\"removeSecondTurnBtn\" baseClass=\"orangeButton\" dojoType=\"dijit.form.Button\" dojoAttachPoint=\"removeSecondTurnBtn\" dojoAttachEvent=\"onclick:removeSecondTurn\">remove turno</button>\r\n\t  </span>\r\n</div>\r\n</div>\r\n</div>\r\n",
	dayOfWeek:null,
	open:{
		hour:-1,
		min:-1
	},
	close:{
		hour:-1,
		min:-1
	},
	secondTurnStart:{
		hour:-1,
		min:-1
	},
	secondTurnClose:{
		hour:-1,
		min:-1
	},
	constructor : function(args) {	
		this.dayOfWeek=args.dayOfWeek;
		this.open.hour=args.startHour;
		this.open.min=args.startMinute;
		this.close.hour=args.closeHour;
		this.close.min=args.closeMinute;
		
		this.secondTurnStart.hour=args.secondTurnStartHour;
		this.secondTurnStart.min=args.secondTurnStartMinute;
		this.secondTurnClose.hour=args.secondTurnCloseHour;
		this.secondTurnClose.min=args.secondTurnCloseMinute;
		
		this.value={
			open:{h:this.open.hour,m:this.open.min},
			close:{h:this.close.hour,m:this.close.min},
			hasSecondTurn:false,
			isClosed:args.isClosed
		}
		if(this.secondTurnStart.hour!=undefined && this.secondTurnStart.hour!=-1){
			this.value.hasSecondTurn=true;
			this.value.secondTurnStart={h:this.secondTurnStart.hour,m:this.secondTurnStart.min};
			this.value.secondTurnClose={h:this.secondTurnClose.hour,m:this.secondTurnClose.min};
		}
	},
	dayOfWeekLabel:'UNDEFINED',
	postMixInProperties : function() {
		this.i18nStrings=dojo.i18n.getLocalization("com.copacabana", "TimeRangeChooserStrings");
		
		this.dayOfWeekLabel=this.i18nStrings['label_'+this.dayOfWeek];
		
	},
	postCreate : function() {
		
	},
	createTimeControl:function(date,dom){
		var tt= new dijit.form.TimeTextBox({
            name: '',
            value: date,
            constraints: {
            	selectOnClick:true,
            	spanLabel:true,
                timePattern: 'HH:mm',
                clickableIncrement: 'T00:15:00',
                visibleIncrement: 'T01:00:00',
                visibleRange: 'T02:00:00'
            }
        },
        dom);
		
		return tt;
	},
	getDateFromStruct:function(obj){
		var d= new Date(1970, 01, 01, obj.hour, obj.min, 00,00);
		
		return d;
	},
	createRadioButtons:function(isClosed){
		var radioClosedDom = dojo.create('input',{},this.openStatusChooser);
		var radioClosed = new dijit.form.RadioButton({
			checked: true,
			value: "isClosed",
			name: "openStatus_"+this.dayOfWeek,
			//checked:isClosed,
			onChange:dojo.hitch(this,function(newValue){
				this.onClosedState(true)
			})
		},
		radioClosedDom);
		dojo.create('label',{'for':'openStatus',innerHTML:'Fechado'},this.openStatusChooser)
		dojo.create('span',{innerHTML:' '},this.openStatusChooser)

		var radioOpenDom = dojo.create('input',{},this.openStatusChooser);
		var radioOpen = new dijit.form.RadioButton({
			checked: true,
			value: "isOpen",
			name: "openStatus_"+this.dayOfWeek,
			//checked:!isClosed,
			onChange:dojo.hitch(this,function(newValue){
				this.onClosedState(false)
			})
		},
		radioOpenDom);
		dojo.create('label',{'for':'openStatus',innerHTML:'Aberto'},this.openStatusChooser);
		
		radioOpen.attr('value',!this.isClosed);
		radioClosed.attr('value',this.isClosed);
console.log(this.dayOfWeek,this.isClosed)


	},
	startup:function(){
		
		dojo.parser.parse(this.domNode);
		
		this.addSecondTurnDOM= dojo.query(".addSecondTurnBtn",this.domNode)[0];
		dojo.connect(this.addSecondTurnDOM,'onclick',this,this.clicked);
		
		this.removeSecondTurnDOM=dojo.query(".removeSecondTurnBtn",this.domNode)[0];
		dojo.connect(this.removeSecondTurnDOM,'onclick',this,this.removeSecondTurn);
		this.createRadioButtons(this.isClosed);
		
		var opendate = this.getDateFromStruct(this.open);
		var closedate = this.getDateFromStruct(this.close);
		this.openTime= this.createTimeControl(opendate,this.openTimeSection);		
		this.closeTime= this.createTimeControl(closedate,this.closeTimeSection);
		
		if(this.secondTurnStart.hour!=undefined && this.secondTurnStart.hour!=-1){
			this.createSecondTurnSection();			
		}
		
		this.inputForm= dojo.create("input",{type:'hidden',name:this.dayOfWeek,value:''},this.domNode);
		this.inputClosedForm= dojo.create("input",{type:'hidden',name:this.dayOfWeek+"_isclosed",value:'false'},this.domNode);
		dojo.subscribe('onFormSubmit',dojo.hitch(this,this.serialize));
		
		
		
	},
	closedButton:null,
	inputClosedForm:null,
	removeSecondTurnDOM:null,
	addSecondTurnDOM:null,
	isClosed:false,
	onClosedState:function(closed){
		
		if(closed==true) {
			this.isClosed=false;	
			dojo.style(this.timeSection,'display','block')
		}else{
			this.isClosed=true;
			dojo.style(this.timeSection,'display','none');
		}
		
	},
	removeSecondTurn:function(evt){
		dojo.style(this.secondTurnSection,'display','none');
		//this.secondTurnStart.destroy();
		//this.secondTurnClose.destroy();
		this.hasSecondTurn=false;
		dojo.style(this.removeSecondTurnDOM,'display','none');
		dojo.style(this.addSecondTurnDOM,'display','inline');
	},
	clicked:function(evt){
		this.secondTurnStart=this.open;
		this.secondTurnStart.hour=this.open.hour+8
		this.secondTurnClose=this.close;
		this.secondTurnClose.hour=this.close.hour+8;
		this.createSecondTurnSection();
	},
	createSecondTurnSection:function(){
		this.hasSecondTurn=true;
		dojo.style(this.secondTurnSection,'display','block');
		var startSecTurn = this.getDateFromStruct(this.secondTurnStart);
		var stopSecTurn = this.getDateFromStruct(this.secondTurnClose);
		this.secondTurnStart= this.createTimeControl(startSecTurn,this.secondTurnStartSection);			
		this.secondTurnClose= this.createTimeControl(stopSecTurn,this.secondTurnCloseSection);
		
		dojo.style(this.removeSecondTurnDOM,'display','inline');
		dojo.style(this.addSecondTurnDOM,'display','none');
		
		
	},
	inputForm:null,
	hasSecondTurn:false,
	validate:function(){	
		
		
		if(this.openTime.isValid()==true ){
			this.serialize();
			return true;
		}else{
			return false;
		}
		
		
		
		
	},
	value:{
					
	},
	serialize:function(){
		this.value= {
			open:{h:this.openTime.attr('value').getHours(),m:this.openTime.attr('value').getMinutes()},
			close:{h:this.closeTime.attr('value').getHours(),m:this.closeTime.attr('value').getMinutes()},
			hasSecondTurn:false,
			isClosed:this.isClosed
		}
		if(this.hasSecondTurn==true){
			this.value.hasSecondTurn=true;
			this.value.secondTurnStart={h:this.secondTurnStart.attr('value').getHours(),m:this.secondTurnStart.attr('value').getMinutes()};
			this.value.secondTurnClose={h:this.secondTurnClose.attr('value').getHours(),m:this.secondTurnClose.attr('value').getMinutes()};
		}
		
		this.inputForm.value=dojo.toJson(this.value)
		}
	
});

}
