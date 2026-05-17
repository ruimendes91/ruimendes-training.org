public class LogicEvaluator {
    
    public static Boolean evaluate(String input) {
        
        //input = input.replaceAll('\\s+', ''); // Remove all whitespace
        
        input = input.deleteWhitespace();
        
        if (String.isBlank(input)) {
            throw new LogicEvaluatorException('An expression cannot be null or empty.');
        }
        
        if (input.equals('0')) {
            return false;
        }
        
        if (input.equals('1')) {
            return true;
        }
        
        if (input.charAt(0) == '('.charAt(0) && input.charAt(input.length() - 1) == ')'.charAt(0)) {
            // Expression is enclosed in parentheses, evaluate recursively
            return evaluate(input.substring(1, input.length() - 1));
        }
        
        Integer index = findOperatorIndex(input);
        system.debug('input: ' + input);
        system.debug('operator index: ' + index);
        if (index == -1) {
            // Expression is a single operand (either '0' or '1')
            return evaluate(input);
        }
        
        String subString1 = input.substring(0, index);
        system.debug('subString1: ' + subString1);
        Boolean operand1 = evaluate(subString1);
        String subString2 = input.substring(index + 1);
        system.debug('subString2: ' + subString2);
        Boolean operand2 = evaluate(subString2);
        Integer operator = input.charAt(index);
        
        if (operator == '&'.charAt(0)) {
            return operand1 && operand2;
        } else if (operator == '|'.charAt(0)) {
            return operand1 || operand2;
        } else {
            throw new IllegalArgumentException('Invalid operator: ' + operator);
        }
        
        
    }
    
    private static Integer findOperatorIndex(String input) {
        /*
        Integer andOperatorIndex = input.indexOf('&');
        Integer orOperatorIndex = input.indexOf('|');
        if(andOperatorIndex == -1) {
            return orOperatorIndex;
        }
        if(orOperatorIndex == -1) {
            return andOperatorIndex;
        }
        if(andOperatorIndex <= orOperatorIndex) {
            return andOperatorIndex;
        }
        else {
            return orOperatorIndex;
        }*/
    
        
        Integer count = 0;
        for (Integer i = input.length() - 1; i >= 0; i--) {
            Integer c = input.charAt(i);
            if (c == ')'.charAt(0)) {
                count++;
            } else if (c == '('.charAt(0)) {
                count--;
            } else if (count == 0 && (c == '&'.charAt(0) || c == '|'.charAt(0))) {
                return i;
            }
        }
        return -1;
    }
    
    private class LogicEvaluatorException extends Exception {}
    
}