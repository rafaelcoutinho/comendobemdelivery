function checkValidForm(cssclass) {
	if (!cssclass) {
		cssclass = ".mandatory";
	}
	var reqs = dojo.query(cssclass);
	var allvalid = true;
	for ( var i = 0; i < reqs.length; i++) {
		try {
			var dreq = dijit.byNode(reqs[i]);
			if (!dreq.isValid()) {

				dijit.showTooltip("* Campo obrigatorio", reqs[i]);
				return false;
			}
		} catch (e) {
			console.log(e);
		}

	}
	return allvalid;
}