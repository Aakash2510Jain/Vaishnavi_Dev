$(document).ready(function () {

    let repVisits = [];
    let selectedEvent;
    let selectedObject;
    let selecteLocation;
    let selectedUser;
    let currentAccount;
    let SelectedRecord;
    let selectedUserId;
    let visiteDateToApex;
    let Leadgeolatitude;
    let Leadgeolongitude;
    let AccountLatitude;
    let AccountLongitude;
    let firstLocation;
    let firstUserId;
    let configureCalendar = function () {
        debugger;
        //repVisits = result.eventList;
        $("#calendar").fullCalendar('removeEvents');
        $("#calendar").fullCalendar('addEventSource', repVisits);
        //$('#calendar-card').show();
    }

    updateDefaultRepAccounts();
    getLocationOnObjectType();
    VisitSchedulerController.getAccountleadList(function (result, event) {
        debugger;
        console.log('--- result Object :' + result);

        $(result).each(function (i, e) {
            debugger;
            $("#pick-two").after('<option value="' + result[i] + '">' + result[i] + '</option>');
        });

    }, { escape: false });

    // VisitSchedulerController.fetchPageData(function (result, event) {
    //     console.log('--- result' + result);
    //    debugger;
    //    if (event.status) {
            $('#calendar').fullCalendar({
                header: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'month,agendaWeek,agendaDay'
                },
                themeSystem: "standard",
                defaultDate: new Date(),
                navLinks: true,
                editable: true,
                eventLimit: true,
                events: repVisits,
                dragScroll: true,
                droppable: true,
                weekNumbers: true,
                eventDrop: function (event, delta, revertFunc) {
                    debugger;
                    alert(event.title + " was dropped on " + event.start.format());
                    if (!confirm("Are you sure about this change? ")) {
                        revertFunc();
                    } else {
                        $.each(repVisits, function (i, visit) {
                            if (visit.id === event.id) {
                                repVisits[i].start = event.start._d.getTime();
                            }
                            console.log(repVisits[i]);
                            updateVisitRecord(repVisits[i].id,repVisits[i].start);

                        });
                    }
                },
                eventClick: function (event, jsEvent, view) {
                    selectedEvent = event;
                    $("#modal-heading-01").text(event.title);
                    $("#event-modal").show();
                },
                dayClick: function (date, jsEvent, view) {
                    jsEvent.preventDefault();
                },
                drop: function (date) {
                    visiteDateToApex = date;
                    debugger;
                    repVisits.push({ accountId: $(this).attr("data-accid"), start: date._i });

                    for (var i = 0; i < repVisits.length; i++) {
                        currentAccount = repVisits[i].accountId;
                    }
                    //callGeolocationMethod();
                    // is the "remove after drop" checkbox checked?
                    if ($('#drop-remove').is(':checked')) {
                        // if so, remove the element from the "Draggable Events" list
                        $(this).remove();
                    }
                },
                eventConstraint: {
                    start: moment().format('YYYY-MM-DD'),
                    end: '2100-01-01' // hard coded goodness unfortunately
                }
            });
           
       // }
        $("#spinner").hide();
   // }, { escape: false });


    function callGeolocationMethod() {
        debugger;
        VisitSchedulerController.getTestRecord(currentAccount, function (result, event) {
            debugger;
            console.log('--- result Object :' + result);
            if (result) {
                for (var key in result) {
                    if (key == "Geolocation__Longitude__s") {
                        Leadgeolatitude = result.Geolocation__Latitude__s;
                        Leadgeolongitude = result.Geolocation__Longitude__s;
                        callVisitCreateRecordMethod();
                       console.log("Lead Found Lead Method Called")
                        break;
                    }
                    else if (key == "Geo_Location__Latitude__s") {
                       AccountLatitude = result.Geo_Location__Latitude__s;
                          AccountLongitude = result.Geo_Location__Longitude__s;
                        callVisitAccountCreateRecordMethod();
                        console.log("Account Found Account Method Called")
                        break;
                    }
                }
            }
        }, { escape: false });
    }

    function callVisitCreateRecordMethod() {
        let apexDate = visiteDateToApex.toISOString();
        debugger;
        VisitSchedulerController.createVisitObjectType(currentAccount, selectedUserId, apexDate, Leadgeolatitude, Leadgeolongitude, function (result, event) {
            debugger;
            console.log('--- result Object :' + result);
            if (result.length != null) {
                alert("VISIT Created Successfully !")
            }
        }, { escape: false });

    }

    function callVisitAccountCreateRecordMethod() {
        let apexDate = visiteDateToApex.toISOString();
        debugger;
        VisitSchedulerController.createVisitObjectType(currentAccount, selectedUserId, apexDate, AccountLatitude, AccountLongitude, function (result, event) {
            debugger;
            console.log('--- result Object :' + result);
            if (result.length != null) {
                alert("VISIT Created Successfully !")
            }
        }, { escape: false });

    }

    $("#upsert-visit").click(function () {
        $("#spinner").show();
        debugger;
        var salesRep = $('#user-select').find(":selected").val();
        if (salesRep && repVisits && repVisits.length > 0) {
            let visits = [], visit;
            for (let i = 0; i < repVisits.length; i++) {
                visit = {};
                visit.id = repVisits[i].id;
                //visit.Name = repVisits[i].title;
                visit.Account__c = repVisits[i].accountId;
                visit.Planned_visit_date__c = repVisits[i].start;
                visit.Assigned_User__c = salesRep;
                visits.push(visit);
            }
            VisitSchedulerController.createVisits(visits, function (result, event) {
                console.log('--- result' + result);
                debugger;
                if (event.status) {
                    console.log('event created successfully');
                }
                $("#spinner").hide();
            }, { escape: false });
        }
        else {
            $("#spinner").hide();
            alert('Please select visit inorder to create.');
        }

    });

    $("#search-account").click(function () {
        debugger;
        $("#search-pannel").toggle();
    });

    $("#search-dealer").click(function () {
        debugger;
        let userId = $("#user-select option:selected").val();
        if (userId == undefined || userId === "") {
            alert('Please select sales rep in-order to search');
            return;
        }
        var searchString = $('#search-box').val();
        if (searchString == undefined || searchString.length < 3) {
            alert('You need to provide at least 3 characters to search.');
            return;
        }
        $("#spinner").show();
        debugger;
        selecteLocation = $('#user-selectlocation :selected').text();
        VisitSchedulerController.getRepAccounts(selectedUser, searchString, selecteLocation, function (accountList, event) {
            if (event.status) {
                if (accountList && accountList.length == 0) {
                    alert('No Records found.');
                } else {
                    $("#event-container").empty();
                    $(accountList).each(function (i, e) {
                        $("#event-container").append(
                            '<div class="fc-event" data-accid="' + accountList[i].Id + '">' + accountList[i].Name + '</div>'
                        );
                    });
                    setEventDraggable();
                }

            } else {
                console.log(result);
                alert('Something went wrong');
            }
            $("#spinner").hide();
        });
    });

    $("#clear-dealer").click(function () {
        $('#search-box').val("");
        $("#event-container").empty();
    //    updateDefaultRepAccounts($("#user-select option:selected").val());
    });

    $("#delete-event").click(function () {
        debugger;
        if (selectedEvent) {
            if (selectedEvent.id) {
                $("#spinner").show();
                VisitSchedulerController.deleteEvent(selectedEvent.id, function (result, event) {
                    if (event.status) {
                        $("#calendar").fullCalendar('removeEvents', selectedEvent._id);
                    } else {
                        alert('Something went wrong, please contact system admin.');
                    }
                    $('#event-modal').hide();
                    $("#spinner").hide();
                });
            } else {
                $("#calendar").fullCalendar('removeEvents', selectedEvent._id);
                $('#event-modal').hide();
            }
        }
    });

    $(".close-modal").click(function () {
        debugger;
        console.log(selectedEvent);
        $('#event-modal').hide();
    });

    $("#user-select").change(function () {
        debugger;
        let userId = $(this).children("option:selected").val();
        if (userId == undefined || userId === "" || userId === "Select...")
            $("#upsert-visit").prop('disabled', true);
        $("#event-container").empty();
        // updateDefaultRepAccounts(userId);
        // getLocationOnObjectType();

    });

    $("#user-selectRecords").change(function () {
        debugger;
        $("#search-pannel").toggle();
        SelectedRecord = $('#user-selectRecords :selected').text();


    });

    $("#user-selectUser").change(function () {
        debugger;
        getUser();

    });

    function getLocationOnObjectType() {
        debugger;
        VisitSchedulerController.getAllLocationRecords(function (result, event) {
            debugger;
            console.log('--- result Object :' + result);

            // $(result).each(function (i, e) {
            //     debugger;
            //     $("#pick-four").after('<option value="' + result[i] + '">' + result[i].Name + '</option>');
            // });

            $("#user-selectlocation").empty();
            var mySelect = $('#user-selectlocation');
            debugger;
            $(result).each(function (i, e) {
                 firstLocation = result[0].Name;
                 callGetUserDataFirst();
                debugger;
                mySelect.append(
                    '<option value="' + result[i].Id + '">' + result[i].Name + '</option>' + '<br>'
                );
            });
            

        }, { escape: false });
    }

    // New First
    function updateVisitRecord(visitId,startdate) {
        VisitSchedulerController.updateVisit(visitId, startdate, function (result, event) {
            debugger;
            if (event.status) {
             
            } else {
                console.log(result);
                alert('Something went wrong');
            }
            $("#spinner").hide();
        });
    }

    function getUserFirstDetails(selectedUserId) {
            debugger;
            selectedUser = $('#user-selectUser :selected').text();
            if (selectedUser != null && firstLocation != null && selectedObject == 'Opportunity') {
                debugger;
                VisitSchedulerController.getRepAccounts(selectedUser, firstLocation, function (accountList, event) {
                    if (event.status) {
                        if (accountList && accountList.length == 0) {
                            alert('No Records found.');
                        } else {
                            $("#event-container").empty();
                            $(accountList).each(function (i, e) {
                                $("#event-container").append(
                                    '<div class="fc-event" data-accid="' + accountList[i].Id + '">' + accountList[i].Name + '</div>'
                                );
                            });
                            setEventDraggable();
                        }
                    } else {
                        console.log(result);
                        alert('Something went wrong');
                    }
                    $("#spinner").hide();
                });
            } else if (selectedUser != null && firstLocation != null && selectedObject == 'Lead') {
            VisitSchedulerController.getRepLeads(selectedUserId, firstLocation, function (accountList, event) {
                debugger;
                if (event.status) {
                    if (accountList.length == 0  && selectedUser != 'Select...') {
                        $("#event-container").empty();
                        alert('No Records found !');
                    } else {
                        $("#event-container").empty();
                        $(accountList).each(function (i, e) {
                            $("#event-container").append(
                                '<div class="fc-event" data-accid="' + accountList[i].Id + '">' + accountList[i].Name + '</div>'
                            );
                        });
                        setEventDraggable();
                    }

                } else {
                    console.log(result);
                    alert('Something went wrong');
                }
                $("#spinner").hide();
            });
        }
    }

    // New First

    function getUser() {
        selectedUser = $('#user-selectUser :selected').text();
        if (selectedUser != null && selecteLocation != null && selectedObject == 'Account') {
            debugger;
            VisitSchedulerController.getRepAccounts(selectedUser, selecteLocation, function (accountList, event) {
                if (event.status) {
                    if (accountList && accountList.length == 0) {
                        alert('No Records found.');
                    } else {
                        $("#event-container").empty();
                        $(accountList).each(function (i, e) {
                            $("#event-container").append(
                                '<div class="fc-event" data-accid="' + accountList[i].Id + '">' + accountList[i].Name + '</div>'
                            );
                        });
                        setEventDraggable();
                    }

                } else {
                    console.log(result);
                    alert('Something went wrong');
                }
                $("#spinner").hide();
            });
        } else if (selectedUser != null && selecteLocation != null && selectedObject == 'Lead') {
            debugger;
            VisitSchedulerController.getRepLeads(selectedUser, selecteLocation, function (accountList, event) {
                debugger;
                if (event.status) {
                    if (accountList.length == 0 && selectedUser != 'Select...') {
                        $("#event-container").empty();
                        alert('No Records found !');

                        //     $('#mySe')
                        //     .find('option')
                        //     .remove()
                        //   .end()
                        //   .append('<option value="whatever">text</option>')
                        // ;

                    } else {
                        $("#event-container").empty();
                        $(accountList).each(function (i, e) {
                            $("#event-container").append(
                                '<div class="fc-event" data-accid="' + accountList[i].Id + '">' + accountList[i].Name + '</div>'
                            );
                        });
                        setEventDraggable();
                    }

                } else {
                    console.log(result);
                    alert('Something went wrong');
                }
                $("#spinner").hide();
            });
        }
    }

    $("#user-selectlocation").change(function () {
        debugger;
        selecteLocation = $('#user-selectlocation :selected').text();
        callGetUserData();


    });


    function callGetUserDataFirst() {
        debugger;
        VisitSchedulerController.fetchGroupmemeber(firstLocation, function (result, event) {
            debugger;
            if (event.status) {
                if (result.length > 0) {
                    firstUserId = result[0].Id;
                    for (var i = 0; i < result.length; i++) {
                        selectedUserId = result[i].Id;
                    }
                    $("#user-selectUser").empty();
                    var mySelect = $('#user-selectUser');
                    $(result).each(function (i, e) {
                        mySelect.append(
                            '<option value="' + result[i].Id + '">' + result[i].LastName + '</option>' + '<br>'
                        );
                    });
                }
                console.log("User Record ::" + result);
                getUserFirstDetails(selectedUserId);
            }
            else {
                alert("Something went wrong !")
            }
        }, { escape: false });
    }


    function callGetUserData() {
        // $('#pick-none').empty();
        debugger;
        VisitSchedulerController.fetchGroupmemeber(selecteLocation, function (result, event) {
            debugger;
            if (event.status) {
                if (result.length > 0) {

                   
                    for (var i = 0; i < result.length; i++) {
                        selectedUserId = result[i].Id;
                    }
                    
                    // $(result).each(function (i, e) {
                    //     debugger;
                    //     $("#pick-none").append('<option value="'+result[i].Id+'">'+result[i].LastName+'</option>');

                    // });

                    $("#user-selectUser").empty();
                    var mySelect = $('#user-selectUser');
                    $(result).each(function (i, e) {
                        mySelect.append(
                            '<option value="' + result[i].Id + '">' + result[i].LastName + '</option>' + '<br>'
                        );
                    });

                }
                console.log("User Record ::" + result);
                getUser();
            }
            else {
                alert("Something went wrong !")
            }



        }, { escape: false });
    }




    function updateDefaultRepAccounts() {

        $("#event-container").hide();
        $("#search-pannel").hide();
        $("#search-account").hide();
        $("#upsert-visit").prop('disabled', true);
        $("#spinner").show();
            $("#event-container").show();
            $("#upsert-visit").prop('disabled', false);
            $("#search-account").show();
            VisitSchedulerController.getAllLeads( function (result, event) {
                selectedObject = $('#user-select :selected').text();

               // callLeadRecordMethod();
                debugger;
                if (event.status) {

                    repVisits = [];
                    for (let i = 0; i < result.length; i++) {
                        let calVisit = {};
                        calVisit.id = result[i].Id;
                        if(result[i].Lead__r != undefined){
                            calVisit.title = result[i].Lead__r.Name__c;
                        }else{
                            calVisit.title = result[i].Name;
                        }
                        calVisit.start = result[i].Planned_visit_date__c;
                        calVisit.end = result[i].Planned_visit_date__c;
                        repVisits.push(calVisit);
                    }
                    console.log(repVisits);

                    $(result.accountList).each(function (i, e) {
                        $("#event-container").append(
                            '<div class="fc-event" data-accid="' + result.accountList[i].Id + '">' + result.accountList[i].Name + '</div>'
                        );
                    });
                    setEventDraggable();
                    configureCalendar();
                } else {
                    alert('Something went wrong!');
                }
                $("#spinner").hide();
            });
    }

    function setEventDraggable() {
        /* initialize the external events
        -----------------------------------------------------------------*/
        $('#external-events .fc-event').each(function () {
            // store data so the calendar knows to render an event upon drop
            $(this).data('event', {
                title: $.trim($(this).text()), // use the element's text as the event title
                stick: true // maintain when user navigates (see docs on the renderEvent method)
            });
            // make the event draggable using jQuery UI
            $(this).draggable({
                zIndex: 999,
                revert: true,      // will cause the event to go back to its
                revertDuration: 0  //  original position after the drag
            });
        });
    }

    function getLeadRecords(){
        VisitSchedulerController.getAllLeads( function (result, event) {
            if (event.status) {
                debugger;
                let visits = [];
                for (let i = 0; i < result.length; i++) {
                    visit = {};
                    visit.id = result[i].id;
                    //visit.Name = repVisits[i].title;
                    visit.Account__c = result[i].accountId;
                    visit.Planned_visit_date__c = result[i].start;
                    visit.Assigned_User__c = salesRep;
                    visits.push(visit);
                }
                configureCalendar();
            } else {
                console.log(result);
                alert('Something went wrong');
            }
            $("#spinner").hide();
        });
    }
});