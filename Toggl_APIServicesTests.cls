/**
 * Created by Chris Gibson on 7/12/2021.
 */

@IsTest
private class Toggl_APIServicesTests {
    @IsTest
    static void RunDetailReportMock() {

        Test.setMock(HttpCalloutMock.class, new Toggl_CalloutMock());
        Toggl_CalloutMock.ChosenEndpoint = Toggl_CalloutMock.Endpoints.DETAIL_REPORT;
        Toggl_Utilities.DetailReportJSONWrapper detailWrapper = Toggl_APIServices.GetDetailReport(Datetime.now(),Datetime.now(),1);
        System.assert(detailWrapper.total_count == '2');

    }

//    @IsTest
//    static void RunTaskCreateMock() {
//
//        Test.setMock(HttpCalloutMock.class, new Toggl_CalloutMock());
//        Toggl_CalloutMock.ChosenEndpoint = Toggl_CalloutMock.Endpoints.TASK_CREATE;
//        String togglTask = '{"task":{"active":false,"estimated_seconds":3600,"fields":"done_seconds,uname"}}';
//        Toggl_Utilities.TaskJSONWrapper taskWrap = (Toggl_Utilities.TaskJSONWrapper)JSON.deserialize(togglTask,Toggl_Utilities.TaskJSONWrapper.class);
//        Toggl_Utilities.ResponseJSONWrapper responseWrap = Toggl_APIServices.CreateTogglTask(taskWrap);
//        System.assert(responseWrap.data.id != null);
//    }
}