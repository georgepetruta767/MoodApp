import { Injectable } from '@angular/core';
import {HttpClient, HttpHeaders} from "@angular/common/http";
import {EventModel} from "../models/event.model";
import {environment} from "../../../../environments/environment";

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

  public updateEvent(eventModel: EventModel): Promise<any> {
    return this.http.post<any>(`${environment.api}/Events/Update`, eventModel, {
      headers: new HttpHeaders({
        'Authorization': `Bearer ${sessionStorage.getItem('bearerToken')}`
      })
    }).toPromise();
  }
}
