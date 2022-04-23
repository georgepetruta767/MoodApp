import { Injectable } from '@angular/core';
import {HttpClient, HttpHeaders} from "@angular/common/http";
import {EventModel} from "../models/event.model";
import {environment} from "../../../../environments/environment";
import axios from 'axios';

var options = {
  method: 'GET',
  url: 'https://api.ip2loc.com/QjEGnNRgEV7CzpQi08ICP3RB1gCGoGGs/detect?include=city',
  params: {latlng: '40.714224,-73.96145', language: 'en'},
  headers: {
    'x-rapidapi-key': 'QjEGnNRgEV7CzpQi08ICP3RB1gCGoGGs',
    'x-rapidapi-host': 'google-maps-geocoding.p.rapidapi.com'
  }
};

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
  }

  public getEvents(): Promise<Array<EventModel>> {
    return this.http.get<Array<EventModel>>(`${environment.api}/Events/Get`, {
      headers: new HttpHeaders({
        'Authorization': `Bearer ${sessionStorage.getItem('bearerToken')}`
      })
    }).toPromise();
  }

  public getEventById(eventId: string): Promise<EventModel> {
    return this.http.get<EventModel>(`${environment.api}/Events/GetEventById?id=${eventId}`, {
      headers: new HttpHeaders({
        'Authorization': `Bearer ${sessionStorage.getItem('bearerToken')}`
      })
    }).toPromise();
  }

  public updateEvent(eventModel: EventModel): Promise<any> {
    console.log(eventModel);
    return this.http.post<any>(`${environment.api}/Events/Update`, eventModel, {
      headers: new HttpHeaders({
        'Authorization': `Bearer ${sessionStorage.getItem('bearerToken')}`
      })
    }).toPromise();
  }

  public deleteEvent(eventId: string): Promise<any> {
    return this.http.delete(`${environment.api}/Events/Delete?id=${eventId}`, {
      headers: new HttpHeaders({
        'Authorization': `Bearer ${sessionStorage.getItem('bearerToken')}`
      })
    }).toPromise();
  }
}
