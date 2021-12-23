{{/*
Common labels
*/}}
{{- define "elastic.labels" -}}
helm.sh/chart: {{ .Values.global.name }}
app.kubernetes.io/managed-by: Helm
{{ include "elastic.selectorLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "elastic.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.global.name }}
app.kubernetes.io/instance: {{ .Values.global.name }}
{{- end }}