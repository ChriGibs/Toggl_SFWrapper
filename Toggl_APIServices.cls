/**
 * Created by Chris Gibson on 1/8/21.
 */

public with sharing class Toggl_APIServices {

    @Future(Callout=true)
    public static void CreateProject(String togglProjectWrappers){

        Map<Id,Toggl_Utilities.ProjectJSONWrapper> projectWrappers = (Map<Id,Toggl_Utilities.ProjectJSONWrapper>)JSON.deserialize(togglProjectWrappers,Map<Id,Toggl_Utilities.TaskJSONWrapper>.class);
        String url = Toggl_Constants.REST_API_BASE_URL + Toggl_Constants.ENDPOINTS.get('projects') + '';

        HttpRequest request = createBaseRequest(url,'POST');
        String body = getBody(projectWrappers);

        request.setBody(body);

        HttpResponse response = sendHTTPRequest(request, url);
        if(response != null){
            System.debug(response.getBody());
        }
    }


    public static Toggl_Utilities.ResponseJSONWrapper CreateTogglTask(Toggl_Utilities.TaskJSONWrapper taskWrapper) {

        String url = Toggl_Constants.REST_API_BASE_URL + Toggl_Constants.ENDPOINTS.get('tasks') + '';
        HttpRequest request = createBaseRequest(url, 'POST');

        String body = getBody(taskWrapper);
        request.setBody(body);

        HttpResponse response = sendHTTPRequest(request, url);
        if (response == null){
            return null;
        }

        String responseBody = response.getBody();
        Toggl_Utilities.ResponseJSONWrapper requestWrapper = Toggl_Utilities.parseRequestJSONWrapper(responseBody);
        return requestWrapper;
    }


    public static Toggl_Utilities.ResponseJSONWrapper UpdateTogglTaskStatus(List<Toggl_Utilities.TaskJSONWrapper> taskWrappers) {

        String url = getUrl(taskWrappers, Toggl_Constants.ENDPOINTS.get('tasks'));
        String body = getBody(taskWrappers);

        HttpRequest request = createBaseRequest(url, 'PUT');
        request.setBody(body);

        HttpResponse response = sendHTTPRequest(request, url);
        if (response == null){
            return null;
        }

        String responseBody = response.getBody();
        Toggl_Utilities.ResponseJSONWrapper requestWrapper = Toggl_Utilities.parseRequestJSONWrapper(responseBody);
        System.debug(requestWrapper.toString());
        return requestWrapper;
    }


    /// ToDo: remove isTagUpdate boolean
    public static void UpdateTimeEntriesWithTag(List<Toggl_Utilities.TimeJSONWrapper> timeWrappers,Set<String> tags) {

        String url = getUrl((List<Toggl_Utilities.A_TogglWrapper>)timeWrappers, Toggl_Constants.ENDPOINTS.get('time_entries'));
        String body = '{"time_entry":{"tags":' + JSON.serialize(tags) + ',"tag_action":"add"}}';
        System.debug(body);

        HttpRequest request = createBaseRequest(url, 'PUT');
        request.setBody(body);

        HttpResponse response = sendHTTPRequest(request, url);
        if (response == null){
            return;
        }

//        String responseBody = response.getBody();
//        System.debug(responseBody);
//        Map<String,Object> responseMap = (Map<String,Object>)JSON.deserializeUntyped(responseBody);
//        System.debug(responseMap);
//        Map<String,Object> dataObject = (Map<String,Object>)responseMap.get('data');
//        System.debug(dataObject);

//        return responseMap;
    }

    public static list<Toggl_Utilities.TimeJSONWrapper> GetTimeEntries(Datetime startTime, Datetime endTime) {
        String startTimeForToggl = JSON.serialize(startTime).replaceAll('"','');
        String endTimeForToggl = JSON.serialize(endTime).replaceAll('"','');

        String url = Toggl_Constants.REST_API_BASE_URL + Toggl_Constants.ENDPOINTS.get('time_entries');
        url += '?start_date=' + EncodingUtil.urlEncode(startTimeForToggl, 'UTF-8');
        url += '&end_date=' + EncodingUtil.urlEncode(endTimeForToggl, 'UTF-8');
        HttpRequest request = createBaseRequest(url, 'GET');

        List<Toggl_Utilities.TimeJSONWrapper> timeWrappers = new List<Toggl_Utilities.TimeJSONWrapper>();
        HttpResponse response = sendHTTPRequest(request, url);
        if (response != null) {
            System.debug(response.getBody());
            timeWrappers = (List<Toggl_Utilities.TimeJSONWrapper>)JSON.deserialize(response.getBody(),List<Toggl_Utilities.TimeJSONWrapper>.class);
        }

        return timeWrappers;
    }


    public static Toggl_Utilities.DetailReportJSONWrapper GetDetailReport(Datetime startTime, Datetime endTime,Integer startingLocation) {
        return GetDetailReport(startTime,endTime,startingLocation,new Set<String>());
    }
    /**
     * @description This method runs the detailed report endpoint for time entries. This endpoint is limited to 50 records per response
     *              and provides a pagination mechanism to continually call all data. Suggested implementation is to use some sort of queuable
     *              processes that continually call until the total number of records have been processed. The DetailReportJSONWrapper object
     *              holds the information necessary to implement this type of behavior.
     *
     * @param startTime - a DateTime representing the lower date boundary of the time records to be returned.
     * @param endTime - a DateTime representing the upper date boundary of the time records to be returned.
     * @param startingLocation - The page of information that should be returned
     * @param togglUserIds - a Set<String> that represents which user Ids we want to retrieve.
     *
     * @return List<Toggl_Utilities.DetailReportJSONWrapper> - a list of all the time entry wrappers found in Toggl based on the specified parameters.
     */
    public static Toggl_Utilities.DetailReportJSONWrapper GetDetailReport(Datetime startTime, Datetime endTime,Integer startingLocation, Set<String> togglUserIds) {
        String startTimeForToggl = startTime.format('yyyy-MM-dd');
        String endTimeForToggl = endTime.format('yyyy-MM-dd');

        String url = Toggl_Constants.REST_API_REPORT_URL + Toggl_Constants.REPORT_ENDPOINTS.get('details');
        url += '?workspace_id=' + Toggl_Constants.WORKSPACE_ID;
        url += '&since=' + EncodingUtil.urlEncode(startTimeForToggl, 'UTF-8');
        url += '&until=' + EncodingUtil.urlEncode(endTimeForToggl, 'UTF-8');
        url += '&user_agent=udsf';
        if(startingLocation > 1){
            url += '&page='+startingLocation;
        }
        System.debug('Checking Toggl IDs in Detail Report: ');
        System.debug(togglUserIds);
        if(togglUserIds.size() > 0){
            url += '&user_ids=';
            for(String curUserId : togglUserIds) {
                url += curUserId + ',';
            }
        }
        url = url.substring(0,url.length() - 1);
        HttpRequest request = createBaseRequest(url, 'GET');

        List<Toggl_Utilities.TimeJSONWrapper> timeWrappers = new List<Toggl_Utilities.TimeJSONWrapper>();
        HttpResponse response = sendHTTPRequest(request, url);
        Toggl_Utilities.DetailReportJSONWrapper wrap = (Toggl_Utilities.DetailReportJSONWrapper)JSON.deserialize(response.getBody().replace('"end":','"end_x":'),Toggl_Utilities.DetailReportJSONWrapper.class);
        return wrap;
    }

    //region private helper methods
    private void updateTasksWithTogglIds(Map<String,String> togglIdsByTaskId){

        try{
            System.enqueueJob(new Toggl_Q_SyncTasksToSF(togglIdsByTaskId));

        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
    }

    private static String getUrl(List<Toggl_Utilities.A_TogglWrapper> taskWrappers, String endpoint) {
        System.debug(taskWrappers);
        String taskIdsForURL = '';
        Integer counter = 0;
        for (Toggl_Utilities.A_TogglWrapper curTaskWrap: taskWrappers) {
            taskIdsForURL += curTaskWrap.getId();
            if (counter != taskWrappers.size() - 1) {
                taskIdsForURL += ',';
                counter++;
            }
        }

        String url = Toggl_Constants.REST_API_BASE_URL + endpoint + '/' + taskIdsForURL;
        return url;
    }

    private static String getBody(Toggl_Utilities.TaskJSONWrapper taskWrapper) {
        String body = '{"task":';
        body += JSON.serialize(taskWrapper,true) + ',';
        body = body.substring(0, body.length() - 1);
        body += '}';
        return body;
    }

    private static String getBody(List<Toggl_Utilities.TaskJSONWrapper> taskWrappers) {
        String body = '{"task":';
        for (Toggl_Utilities.TaskJSONWrapper curTaskWrap : taskWrappers) {
            body += JSON.serialize(curTaskWrap,true) + ',';
        }
        body = body.substring(0, body.length() - 1);
        body += '}';
        return body;
    }

    private static String getBody(Map<Id,Toggl_Utilities.ProjectJSONWrapper> projectWrappers) {
        String body = '{"project":';
        for (String curKey : projectWrappers.keySet()) {
            Toggl_Utilities.ProjectJSONWrapper curWrap = projectWrappers.get(curKey);
            body += JSON.serialize(curWrap,true) + ',';
        }
        body = body.substring(0, body.length() - 1);
        body += '}';
        return body;
    }


    private static String getBody(List<Toggl_Utilities.TimeJSONWrapper> timeWrappers) {

        String body = '{"time":';
        for (Toggl_Utilities.TimeJSONWrapper curTimeWrap : timeWrappers) {
            body += JSON.serialize(curTimeWrap,true) + ',';
        }
        body = body.substring(0, body.length() - 1);
        body += '}';
        return body;
    }

    private static HttpResponse sendHTTPRequest(HttpRequest request, String url) {
        try {
            Http client = new Http();
            HttpResponse response = client.send(request);
            System.debug(url);
            System.debug(response.getStatusCode());
            System.debug(response.getStatus());
            System.debug(response.getBody());
            return response;
        } catch (CalloutException ce) {
            system.debug(ce.getMessage());
            return null;
        }
    }

    private static HttpRequest createBaseRequest(String url,String method) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setHeader('Authorization', Toggl_Constants.BASIC_AUTH_HEADER_VALUE);
        request.setHeader('Content-Type', 'application/json');
        request.setMethod(method);
        return request;
    }

    //endregion

}