import {Component, OnInit} from '@angular/core';

import * as echarts from 'echarts';
import {ResultService} from "./result.service";

type EChartsOption = echarts.EChartsOption;

@Component({
  selector: 'app-results',
  templateUrl: './results.component.html',
  styleUrls: ['./results.component.scss'],
})
export class ResultsComponent implements OnInit {
  public meanGradeOverSeasonChart: EChartsOption;

  constructor(private resultsService: ResultService) { }

  public async ngOnInit() {
    this.meanGradeOverSeasonChart = await this.resultsService.getMeanGradePerSeasonValues();
    console.log(this.meanGradeOverSeasonChart)
  }

}
