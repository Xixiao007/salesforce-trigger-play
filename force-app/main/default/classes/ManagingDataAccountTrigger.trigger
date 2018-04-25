trigger ManagingDataAccountTrigger on Account (after update) {

  ManagingApex1.handleAccountUpdate(trigger.new, trigger.oldMap);

}
