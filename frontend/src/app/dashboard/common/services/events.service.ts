import { Injectable } from '@angular/core';
import {HttpClient, HttpHeaders} from "@angular/common/http";
import {EventModel} from "../models/event.model";
import {environment} from "../../../../environments/environment";

/*const http = require("https");

const options = {
  "method": "GET",
  "hostname": "telize-v1.p.rapidapi.com",
  "port": null,
  "path": "/location?callback=getlocation",
  "headers": {
    "x-rapidapi-host": "telize-v1.p.rapidapi.com",
    "x-rapidapi-key": "00f6a9797fmshad1fd50095aaa5bp120936jsnd7ec63f6b6eb",
    "useQueryString": true
  }
};

const req = http.request(options, function (res) {
  const chunks = [];

  res.on("data", function (chunk) {
    chunks.push(chunk);
  });

  res.on("end", function () {
    const body = Buffer.concat(chunks);
    console.log(body.toString());
  });
});*/

@Injectable({
  providedIn: 'root'
})
export class EventsService {

  constructor(private http: HttpClient) { }

  public addEvent(eventModel: EventModel): Promise<any> {
    return this.http.post(`${environment.api}/Events/Add`, eventModel, {
      headers: new HttpHeaders({
        'Authorization': `Bearer ${sessionStorage.getItem('bearerToken')}`
      })
    }).toPromise();

    //return req.end();

  }

  public getEvents(): Promise<Array<EventModel>> {
    return this.http.get<Array<EventModel>>(`${environment.api}/Events/Get`, {
      headers: new HttpHeaders({
        'Authorization': `Bearer ${sessionStorage.getItem('bearerToken')}`
      })
    }).toPromise();
  }

  public updateEvent(eventModel: EventModel): Promise<any> {
    return this.http.post<any>(`${environment.api}/Events/Update`, eventModel, {
      headers: new HttpHeaders({
        'Authorization': `Bearer ${sessionStorage.getItem('bearerToken')}`
      })
    }).toPromise();
  }
}
