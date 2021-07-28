/**
 * Created by chrisgibson on 1/9/21.
 */

@IsTest
private class Toggl_UtilitiesTests {
    @IsTest
    static void TestResponseJSONWrapper() {
        String sampleResponseJSONWrapper = '{' +
                '"data":' +
                '   {' +
                '"name":"Test Response Wrap",' +
                '"id":"123456",' +
                '"wid":"12345",' +
                '"active":true,' +
                '"at":"2021-07-11T23:16:15",' +
                '"estimated_seconds":"1234561",' +
                '"uname":"Chris Gibson",' +
                '"done_seconds":"1234561"' +
                '}' +
                '}';

        Toggl_Utilities.ResponseJSONWrapper wrapData = Toggl_Utilities.parseRequestJSONWrapper(sampleResponseJSONWrapper);
    }

    @IsTest
    static void TestTaskJSONWrapper() {
        String sampleTaskJSONWrapper = '{' +
                '"data":' +
                '   {' +
                '"name":"A new task",'+
                '"id":1335076912,'+
                '"wid":888,'+
                '"pid":777,'+
                '"active":true,'+
                '"estimated_seconds":0'+
                '}' +
                '}';

        Toggl_Utilities.TaskJSONWrapper wrapData = Toggl_Utilities.parseTaskJSONWrapper(sampleTaskJSONWrapper);
    }


    @IsTest
    static void TestTimeJSONWrapper() {
        String sampleTaskJSONWrapper = '{' +
                '"data":' +
                '{' +
                '"id":43669578,'+
                '"pid":1930589,'+
                '"tid":null,'+
                '"uid":777,'+
                '"description":"tegin tööd",'+
                '"start":"2013-05-20T06:55:04",'+
                '"end":"2013-05-20T10:55:04",'+
                '"updated":"2013-05-20T13:56:04",'+
                '"dur":14400000,'+
                '"user":"John Swift",'+
                '"use_stop":true,'+
                '"client":"Avies",'+
                '"project":"Toggl Desktop",'+
                '"task":null,'+
                '"billable":8.00,'+
                '"is_billable":true,'+
                '"cur":"EUR",'+
                '"tags":["paid"]'+
                '}' +
                '}';

        Toggl_Utilities.TimeJSONWrapper wrapData = Toggl_Utilities.parseTimeJSONWRapper(sampleTaskJSONWrapper);
    }

    
}