<div dojoType="dijit.Dialog" id="plateOptionDialog" title="Opção"
		style="display: none; border: 1px solid black;" execute="teste">
	<form action="/createPlateJson.do" method="post" id="plateOptionForm"
		name="plateOptionForm" dojoType="dijit.form.Form">
		<c:if test="${param.isExecutive==true}">
		<input type="hidden" dojoType="dijit.form.TextBox" name="plate.availableTurn" value="LUNCH" />
		</c:if>
		<input type="hidden" dojoType="dijit.form.TextBox" name="restaurant" />
		<input type="hidden" dojoType="dijit.form.TextBox" name="plate.foodCategory"/>		 
		<input type="hidden" dojoType="dijit.form.TextBox" name="plate.id"  />
		<input type="hidden" dojoType="dijit.form.TextBox" name="plate.extendsPlate"  />
		
	<table>
		<tr>
			<td><label for="name">Nome da opção: </label></td>
			<td><input required="true" class="mandatory"
				dojoType="dijit.form.ValidationTextBox" type="text" trim="true" properCase="true"
				name="plate.title" > <span class="required">*</span></td>
		</tr>
		<tr>
			<td><label for="loc">Descri&ccedil;&atilde;o: </label></td>
			<td><textarea dojoType="dijit.form.SimpleTextarea" trim="true" 
				name="plate.description" rows=4 cols=25></textarea>
			</td>
		</tr>
		<tr>
			<td><label for="date">Valor: </label></td>
			<td><input type="text" name="plate.price"  trim="true" selectOnClick="true" 
				value="0,00" dojoType="dijit.form.CurrencyTextBox" required="true" onchange="addCentsOption"
				class="mandatory" constraints="{fractional:true,required:true}" id="plateOptionPrice"
				invalidMessage="Digite o valor com centavos, por exemplo 10,90">
			<span class="required">*</span></td>
		</tr>		
		<tr>
			<td><label for="name">Disponibilidade: </label></td>
			<td><input dojoType="dijit.form.FilteringSelect"   name="plate.status" id="plateOptionStatus"></td>
		</tr>
		<tr>
			<td><label for="name">É variação de tamanho: </label></td>
			<td><input dojoType="dijit.form.FilteringSelect" name="plate.plateSize" id="plateOptionSize"></td>
		</tr>
		<tr>
			<td colspan="2" align="center">
			<button baseClass="orangeButton" dojoType="dijit.form.Button"
				onclick="com.copacabana.pages.ProfileMenu.savePlateOption()" onkeypress="com.copacabana.pages.ProfileMenu.savePlateOption()">Salvar</button>						

		</tr>
	</table>
	</form>
	</div>
