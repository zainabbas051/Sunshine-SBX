({
	helperMethod : function() {
		
	},
    
    isValid: function (c, id) {
    var validateFields = c.find(id || 'validate');
    var isValid;
    if (validateFields) {
        isValid = [].concat(validateFields).reduce(function (validSoFar, input) {
            input.showHelpMessageIfInvalid();
            return validSoFar && input.get('v.validity').valid;
        }, true);
    }
    return isValid;
}
    
})