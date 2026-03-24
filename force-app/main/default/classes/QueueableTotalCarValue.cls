public with sharing class QueueableTotalCarValue implements Queueable {

    private Set<Id> carIds;
    public QueueableTotalCarValue(Set<Id> carIds){
        this.carIds = carIds;
    }
    public void execute(QueueableContext qc){
        //use aggregate query to calculate total Booked Value
        Map<Id,Decimal> carTotalValues = new Map<Id,Decimal>();
        List<Car__c> carList = new List<Car__c>();
        for(AggregateResult agr:[Select Car__c carId, SUM(Total_Paid_Amount__c) totalValue
                                    from Booking__c where Status__c  = :Constants.BOOKING_CLOSED_STATUS
                                    AND Car__c in :carIds
                                    group by Car__c]){
 
            
                Id carId = (Id)agr.get('carId');
                Decimal totalValue = (Decimal)agr.get('totalValue');
                carTotalValues.put(carId,totalValue);
        } 

        for(Id carId : carIds){
            Car__c car = new Car__c(Id = carId);
            car.Total_Bookings_Value__c = carTotalValues.get(carId);
            carList.add(car);
        }

        try {
            if (carList.size() > 0) {
                update carList;
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
            Log logger = Log.get();
            logger.publish('Exception while updating car records '+e.getMessage());
        }
    }
}              
            
         
    
