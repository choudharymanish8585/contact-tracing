/**
 * CTHealthHeaderController
 * Main controller of CTHealthHeader Aura Component
 * @author Manish
 */
public with sharing class CTHealthHeaderController {
    @AuraEnabled
    public static Map<String, Integer> getPersonHealthStatusCount() {
        return CTPersonController.getHealthStatusCount();
    }

    @AuraEnabled
    public static Map<String, Integer> getLocationHealthStatusCount() {
        return CTLocationController.getStatusCount();
    }
}
