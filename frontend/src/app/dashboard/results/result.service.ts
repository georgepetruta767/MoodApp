import { Injectable } from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {environment} from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class ResultService {

  constructor(private http: HttpClient) { }

  public getBarChartOptions(category: string, type: string, userId: string): Promise<any> {
    return this.http.get(`${environment.resultsApi}/get-bar-grade/${category}/${type}/${userId}`).toPromise();
  }

  public getScatterPlotOptions(): Promise<any> {
    return this.http.get(`${environment.resultsApi}/get-scatter-plot`).toPromise();
  }
}
