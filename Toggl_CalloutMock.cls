/**
 * Created by Chris Gibson on 7/12/2021.
 */

public with sharing class Toggl_CalloutMock implements HttpCalloutMock{

    public enum Endpoints {DETAIL_REPORT,TASK_CREATE,TASK_UPDATE,TIME_X,PROJECT}
    public static Endpoints ChosenEndpoint = Endpoints.DETAIL_REPORT;
    public HttpResponse respond(HttpRequest request) {

        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setHeader('Content-Type', 'application/json');
        if(request.getMethod() == 'GET'){
            if(ChosenEndpoint == Endpoints.DETAIL_REPORT){
                response.setBody(getDetailedReportMock());
            }
            else if(ChosenEndpoint == Endpoints.TASK_CREATE){
                response.setBody(getTaskCreateMock());
            }
            else if(ChosenEndpoint == Endpoints.TASK_UPDATE){
                response.setBody(getTaskUpdateMock());
            }
        }

        response.setStatus('SUCCESS');

        return response;
    }

    private String getDetailedReportMock(){
        return '{'+
                '            "total_grand":23045000,'+
                '            "total_billable":23045000,'+
                '            "total_count":2,'+
                '            "per_page":50,'+
                '            "total_currencies":[{"currency":"EUR","amount":128.07}],'+
                '        "data":['+
                '        {'+
                '        "id":43669578,'+
                '        "pid":1930589,'+
                '        "tid":null,'+
                '        "uid":777,'+
                '        "description":"tegin tööd",'+
                '        "start":"2013-05-20T06:55:04",'+
                '        "end":"2013-05-20T10:55:04",'+
                '        "updated":"2013-05-20T13:56:04",'+
                '        "dur":14400000,'+
                '        "user":"John Swift",'+
                '        "use_stop":true,'+
                '        "client":"Avies",'+
                '        "project":"Toggl Desktop",'+
                '        "task":null,'+
                '        "billable":8.00,'+
                '        "is_billable":true,'+
                '        "cur":"EUR",'+
                '        "tags":["paid"]'+
                '    },{'+
                '    "id":43669579,'+
                '    "pid":1930625,'+
                '    "tid":1334973,'+
                '    "uid":7776,'+
                '    "description":"agee",'+
                '    "start":"2013-05-20T09:37:00",'+
                '    "end":"2013-05-20T12:01:41",'+
                '    "updated":"2013-05-20T15:01:41",'+
                '    "dur":8645000,'+
                '    "user":"John Swift",'+
                '    "use_stop":true,'+
                '    "client":"Apprise",'+
                '    "project":"Development project",'+
                '    "task":"Work hard",'+
                '            "billable":120.07,'+
                '            "is_billable":true,'+
                '            "cur":"EUR",'+
                '            "tags":[]'+
                '            }'+
                '            ]'+
                '            }';
    }

    private String getTaskCreateMock(){
        return '{'+
                '        "data": {'+
                '        "name":"A new task",'+
                '        "id":1335076912,'+
                '        "wid":888,'+
                '        "pid":777,'+
                '        "active":true,'+
                '        "estimated_seconds":0'+
                '    }'+
                '}';
    }

    private String getTaskUpdateMock(){
        return '{'+
                '     "data": {'+
                '     "name":"A new task",'+
                '     "id":1335076912,'+
                '     "wid":888,'+
                '     "pid":777,'+
                '     "active":false,'+
                '     "at":"2013-02-26T15:09:52+00:00",'+
                '     "estimated_seconds":3600,'+
                '     "uname": "John Swift",'+
                '     "done_seconds": 1200'+
                ' }'+
                '}';
    }

}